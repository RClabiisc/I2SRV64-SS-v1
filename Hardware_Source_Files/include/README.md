# Header File Generator (`gen_header.sh`)

The Header File Generator (bash script `gen_header.sh`) generates the Verilog Header file from the given configuration file.

```
Usage:
    gen_header <configuration_file>
```

The configuration file contains the Entries to explain how equivalent line can be generated. The lines beginning with `#` in configuration file are treated as comments. Incorrect Entry Type and empty lines are ignored without Warning or Info. Every fields in configuration entry are filtered for leading and trailing white-spaces. 

## Configuration Entry Types

### file_begin

Format : `file_begin|<IDENTIFIER>|<File Name>`
Example: `file_begin |      CORE_DEFINES    | core_defines.vh`

- Creates New File of name `<File Name>` 
- Adds `ifndef <IDENTIFIER> ` wrapper 
- Starts interpreting next configuration entries for that file.

### file_end

Format: `file_end|<IDENTIFIER>`
Example: `file_end | CORE_DEFINES`

- Ends the current ongoing file if `<IDENTIFIER>` matches
- Adds `endif` wrapper

### comment

Format: `comment|<comment_text>`
Example: `comment |  ROB Defines`

- Prints `<comment_text>` as Verilog Style comment in File if opened

### box_comment

Format: `box_comment|<comment_text>`
Example: `box_comment| uARCH Defines`

- Prints `<comment_text>` as Verilog Style comment encapsulated in bounding box in File if opened

### declare

Format: `declare|<name>|<Expression>`
Example: `declare|ROB_DEPTH|13`

- Creates internal variable of name `<name>` and assigns evaluated value of `<Expression>`. 
- The internal variable can be used in later configuration entries. 
- `declare` will not print anything to file

### vinclude

Format: `vinclude|<file_name>`
Example: `vinclude | core_defines.v`

- Prints in Verilog Include like format to current file if opened.
- Will NOT create internal variable.

### vdefine

Format: `vdefine|<name>|<value>`
Example: `vdefine | MAX_LEN | 2+:3 `

- Prints in Verilog define like format to current file if opened without any alteration to value.
- Will NOT create internal variable.

### define

Format: `define|<name>|<Expression>`
Example: `define | MAX_LEN | 2+:${ROB_DEPTH}

- Evaluates the `<Expression>`  and that value is used to to print in Verilog define like format to current file if opened.
- Also created internal variable with name `<name>` and assigns evaluated value to it.

### blank

Format: `blank`

- Inserts blank line to current file if opened

### include

Format: `include | <config_file_name>`
Example: `include | core_config.cfg`

- Parses only `declare` & `define` type configuration entries from file `<config_file_name>`
- Recursive Include is NOT Supported
- `declare` is interpreted in same way as that would in normal parsing.
- `define` is interpreted like `declare`  during parsing include file `<config_file_name>` i.e. it will not print Verilog define like statement in current file.
- While parsing `declare` & `define` if the variables referenced in `<Expression>` are NOT declared/defined earlier in file being included, can result into error or variable being replaced by NULL String.

### bus_begin

Format: `bus_begin|<IDENTIFIER>|<bus_name>`
Example: `bus_begin|result_bus|RESULT`

- Starts New Bus definitions for `<IDENTIFIER>`
- Resets the `bus_index`. 
- Also saves `<bus_name>` so that it can be pre-pended with bus fields.

### bus_end

Format: `bus_end|<IDENTIFIER>`
Example:`bus_end|result_bus`

- Ends the current bus definition for `<IDENTIFIER>` if it matched with earlier
- Created Verilog define with name `<bus_name>_LEN` and assigns value of `bus_index` to it, representing length of bus.

### bus_field

Format: `bus_field|<field_name>|<Expression>`
Example: `bus_field|VALID|1`

- Creates Verilog define with name `<bus_name>_<field_name>` and assigns cumulative value to it considering `<Expression>` as width of bus field
- `bus_index` is then incremented with evaluated value from `<Expression>`



## Expression Evaluation

- The `<Expression>` is evaluated like typical bash variable substitution.
- The supported features are
  - Variable Substitution: `${<variable_name>}` or `$<variable_name>` will result into substitution of value of variable `<variable_name>` in its place.
  - Command Execution: `$(<cmd> <arguments>)` will evaluate `<cmd>` with arguments `<arguments>` and result will be placed in its place
  - Predefined Commands: The Following Commands are predefined by script
    - `clog2` : Returns the Verilog `$clog2()` like output.
      `$(clog2 127)` will return 7
      `$(clog2 $DISPATCH_RATE)` will return clog2 for value in variable DISPATCH_RATE
    - `max` : Returns the maximum value among arguments.
      `$(max 12 45 8)` will return 45
      `$(max $INT_LEN $FP_LEN)` will return maximum value between value of variables INT_LEN and FP_LEN
    - `math` : Returns the result of bash `let` command when arguments `<arguments>` given to it.
      See bash manual for supported functions
      `$(math 12+3)` will return 15
      `$(math 14+${RETIRE_RATE})` will return value of variable RETIRE_RATE added with 14
  - Predefined Variables: The internal variables which can be reused in configuration entry are
    - `bus_name` : It is `<bus_name>` field from recent `bus_begin` config entry
    - `bus_index` : It is the internal incremental counter used to tract index field in a current bus  

