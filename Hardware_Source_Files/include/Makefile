#Makefile to generate header files
gen_header ?= ./gen_header.sh

.PHONY: help clean

TARGETS = core_config.vh core_typedefs.vh core_defines.vh bus_defines.vh regbit_defines.vh soc_defines.vh

default: all

help:
	@echo "Available Targets"
	@echo "all: Generate All Header Files"
	@echo "<file_name>.v: Generate Single Header file"
	@echo "help: Print help"

%.vh: %.cfg
	@echo "INFO: Generating Header file $@ from $<"
	@$(gen_header) $<

all: $(TARGETS)

clean:
	@rm -rfv $(TARGETS)
