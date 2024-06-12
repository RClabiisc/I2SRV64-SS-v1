#!/bin/bash

#Script Helper Functions
usage() {
    echo "Usage: gen_header.sh <cfg_file>"
}

get_type() {
    echo ${1} | cut -d "|" -f 1 | awk '{ gsub(/^[ \t]+|[ \t]+$/, ""); print }' | tr '[:upper:]' '[:lower:]'
}

get_name() {
    echo ${1} | cut -d "|" -f 2 | awk '{ gsub(/^[ \t]+|[ \t]+$/, ""); print }'
}

get_value() {
    echo "${1}" | cut -d "|" -f 3- | awk '{ gsub(/^[ \t]+|[ \t]+$/, ""); print }'
}

info() {
    if [ -z "$DEBUG" ]; then
        echo $@
    fi
}

#math functions
clog2() {
    let "value=${1}-1"
    let "clog2=0"
    while [ ${value} -gt 0 ]
    do
        let "value=${value}>>1"
        let "clog2=${clog2}+1"
    done
    echo ${clog2}
}

math() {
    cmd="result = $@"
    let "${cmd}"
    echo ${result}
}

max() {
    let "arg=1"
    max=${!arg}
    let "arg=2"
    while [ ! -z "${!arg}" ]
    do
        if [ ${!arg} -gt ${max} ]; then
            max=${!arg}
        fi
        let "arg++"
    done
    echo ${max}
}


#####################################main script

#check args
if [ -z "$1" ]; then
    usage
fi

ifile="$1"
let "lno=1"
while IFS= read -e line
do
    #read entry type
    cfgtype=$(get_type "$line")
    case ${cfgtype} in
        declare)
            #create variable with name & value
            name=$(get_name "$line")
            value=$(get_value "$line")
            value_eval=$(eval echo "${value}")
            if [ -z "${value_eval}" ]; then
                echo "ERR: [${parse_file}:${llno}] Evaluated value for '${value}' is empty"
                exit 1
            fi
            info "INFO: [${ifile}:${lno}] declare ${name}=${value}=${value_eval}"
            declare "${name}=${value_eval}"
            ;;

        include)
            #parse include file for defines only if present
            parse_file="$(get_name "$line")"
            if [ -z "${parse_file}" ] || [ ! -e "${parse_file}" ]; then
                echo "ERR: [${ifile}:${lno}] File '${parse_file}' does NOT exists"
                exit 1
            fi

            info "INFO: [${ifile}:${lno}] include '${parse_file}'"
            #parse define from include file
            let "llno=1"
            while IFS= read -e lline
            do
                ttype=$(get_type "$lline")
                case ${ttype} in
                    declare|define)
                        #create variable with name & value
                        name=$(get_name "$lline")
                        value=$(get_value "$lline")
                        value_eval=$(eval echo "${value}")
                        if [ -z "${value_eval}" ]; then
                            echo "ERR: [${parse_file}:${llno}] Evaluated value for '${value}' is empty"
                            exit 1
                        fi
                        info "INFO: [${parse_file}:${llno}] declare ${name}=${value}=${value_eval}"
                        declare "${name}=${value_eval}"
                        ;;

                    include)
                        echo "WARN: [${parse_file}:${llno}] Recursive Include NOT Supported"
                        ;;

                    *)
                        #echo "WARN: [${parse_file}:${llno}] Include only support 'declare' cfg. Ignoring ${ttype}"
                        ;;
                esac
                let "llno++"
            done < "${parse_file}"
            ;;

        vinclude)
            #echo value in verilog include form
            if [ -z "${outfile}" ]; then
                echo "ERR: [${ifile}:${lno}] No file is opened yet."
                exit 1
            fi
            file_name="$(get_name "$line")"
            echo "\`include \"${file_name}\"" >> ${outfile}
            info "INFO: [${ifile}:${lno}] vinclude '${file_name}'"
            ;;

        comment)
            #echo comment to outfile if present
            if [ -z "${outfile}" ]; then
                echo "ERR: [${ifile}:${lno}] No file is opened yet."
                exit 1
            fi
            comment="$(get_name "$line")"
            echo "" >> ${outfile}
            echo "// ${comment}" >> ${outfile}
            info "INFO: [${ifile}:${lno}] comment '${comment}'"
            ;;

        raw)
            #add specified raw text without any modification
            if [ -z "${outfile}" ]; then
                echo "ERR: [${ifile}:${lno}] No file is opened yet."
                exit 1
            fi
            raw_text="$(get_name "$line")"
            echo "${raw_text}" >> ${outfile}
            info "INFO: [${ifile}:${lno}] raw '${raw_text}'"
            ;;

        box_comment)
            #echo comment in box like form to outfile if present
            if [ -z "${outfile}" ]; then
                echo "ERR: [${ifile}:${lno}] No file is opened yet."
                exit 1
            fi
            comment="$(get_name "$line")"
            echo "" >> ${outfile}
            echo "//--------------------------------------------------------------------" >> ${outfile}
            echo "// ${comment}" >> ${outfile}
            echo "//--------------------------------------------------------------------" >> ${outfile}
            info "INFO: [${ifile}:${lno}] box_comment '${comment}'"
            ;;

        file_begin)
            #create new empty file if not already open
            if [ ! -z "${outfile}" ]; then
                echo "ERR: [${ifile}:${lno}] File '${outfile}' is already open."
                exit 1
            fi

            file_id="$(get_name "$line")"
            outfile="$(get_value "$line")"
            info "INFO: [${ifile}:${lno}] file_begin '${outfile}'"
            echo "//NOTE: This is generated include file from '${ifile}'" > "${outfile}"
            echo "//      Do NOT Modify here. Change the config file and generate this file again" >> "${outfile}"
            echo "" >> "${outfile}"
            echo "\`ifndef INC_${file_id}" >> "${outfile}"
            echo "\`define INC_${file_id}" >> "${outfile}"
            ;;

        file_end)
            #close opened file if already open
            if [ -z "${outfile}" ]; then
                echo "ERR: [${ifile}:${lno}] No File is opened yet."
                exit 1
            fi
            if [ "${file_id}" != "$(get_name "$line")" ]; then
                echo "ERR: [${ifile}:${lno}] File already opened '${file_id}' is not same as to be closed '$(get_name "$line")'"
                exit 1;
            fi

            info "INFO: [${ifile}:${lno}] file_end '${outfile}'"
            echo "" >> "${outfile}"
            echo "\`endif" >> "${outfile}"
            echo "" >> "${outfile}"
            echo "// Generated File '${outfile}' Ends" >> "${outfile}"
            echo "" >> "${outfile}"
            outfile=""
            bus_name=""
            ;;

        define)
            #define = declare + vdefine
            #declare variable and put it in define form in file if opened
            if [ -z "${outfile}" ]; then
                echo "ERR: [${ifile}:${lno}] No File is opened yet."
                exit 1;
            fi

            name=$(get_name "$line")
            value=$(get_value "$line")
            value_eval=$(eval echo "${value}")
            if [ -z "${value_eval}" ]; then
                echo "ERR: [${parse_file}:${llno}] Evaluated value for '${value}' is empty"
                exit 1
            fi
            info "INFO: [${ifile}:${lno}] define ${name}=${value}=${value_eval}"
            declare "${name}=${value_eval}"
            printf "\`define %-31s %s\n" "${name}" "${value_eval}" >> "${outfile}"
            ;;

        vdefine)
            #put variable in verilog define form in file if opened
            if [ -z "${outfile}" ]; then
                echo "ERR: [${ifile}:${lno}] No File is opened yet."
                exit 1;
            fi

            name=$(get_name "$line")
            value=$(get_value "$line")
            info "INFO: [${ifile}:${lno}] vdefine ${name}=${value}"
            printf "\`define %-31s %s\n" "${name}" "${value}" >> "${outfile}"
            ;;

        bus_begin)
            #begin bus if file is open
            if [ -z "${outfile}" ]; then
                echo "ERR: [${ifile}:${lno}] No File is opened yet."
                exit 1;
            fi

            bus_id="$(get_name "$line")"
            bus_name="$(get_value "$line")"
            info "INFO: [${ifile}:${lno}] bus_begin '${bus_name}'"
            let "bus_index=0"
            ;;

        bus_field)
            #create bus field if bus is begined
            if [ -z "${bus_name}" ]; then
                echo "ERR: [${ifile}:${lno}] Bus is not begined yet"
                exit 1
            fi

            name="$(get_name "$line")"
            value="$(get_value "$line")"
            value_eval=$(eval echo "${value}")
            info "INFO: [${ifile}:${lno}] bus_field ${name}=${value}=${value_eval}"

            printf "\`define %-31s %s\n" "${bus_name}_${name}" "${bus_index}+:${value_eval}" >> "${outfile}"
            let "bus_index = $bus_index + $value_eval"
            ;;

        bus_end)
            #end bus by printing length & new line
            if [ -z "${bus_name}" ]; then
                echo "ERR: [${ifile}:${lno}] Bus is not begined yet"
                exit 1
            fi
            if [ "${bus_id}" != "$(get_name "$line")" ]; then
                echo "ERR: [${ifile}:${lno}] bus begined '${bus_id}' is not same as to be ended '$(get_name "$line")"
                exit 1;
            fi

            info "INFO: [${ifile}:${lno}] bus_end '${bus_name}=${bus_index}'"
            printf "\`define %-31s %s\n" "${bus_name}_LEN" "(${bus_index})" >> "${outfile}"
            declare "${bus_name}_LEN=${bus_index}"

            bus_name=")"
            let "bus_index=0"
            ;;

        blank)
            #insert blank line if file is open
            if [ -z "${outfile}" ]; then
                echo "ERR: [${ifile}:${lno}] No File is opened yet."
                exit 1;
            fi

            echo "" >>"${outfile}"
            ;;

        *)
            ;;
    esac
    let "lno++"

done < "${ifile}"

