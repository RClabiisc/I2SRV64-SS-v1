# Sys Clock (differential) pin mapping
set_property BOARD_PIN {clk_p} [get_ports clk_p]
set_property BOARD_PIN {clk_n} [get_ports clk_n]

# CPU Reset pin mapping
set_property BOARD_PIN {reset} [get_ports reset]

# Pin Mapping For Push Buttons
set_property BOARD_PIN {push_buttons_5bits_tri_i_0} [get_ports {push_button_io[0]}]
set_property BOARD_PIN {push_buttons_5bits_tri_i_1} [get_ports {push_button_io[1]}]
set_property BOARD_PIN {push_buttons_5bits_tri_i_2} [get_ports {push_button_io[2]}]
set_property BOARD_PIN {push_buttons_5bits_tri_i_3} [get_ports {push_button_io[3]}]
set_property BOARD_PIN {push_buttons_5bits_tri_i_4} [get_ports {push_button_io[4]}]

# On Board UART Pin Mapping
set_property BOARD_PIN {rs232_uart_txd} [get_ports rs232_uart_txd]
set_property BOARD_PIN {rs232_uart_rxd} [get_ports rs232_uart_rxd]

# I2C Pin Mapping
set_property BOARD_PIN {iic_main_scl_i} [get_ports i2c_scl]
set_property BOARD_PIN {iic_main_sda_i} [get_ports i2c_sda]

# Pin Mapping of LEDs
set_property BOARD_PIN {leds_8bits_tri_o_0} [get_ports {led_io[0]}]
set_property BOARD_PIN {leds_8bits_tri_o_1} [get_ports {led_io[1]}]
set_property BOARD_PIN {leds_8bits_tri_o_2} [get_ports {led_io[2]}]
set_property BOARD_PIN {leds_8bits_tri_o_3} [get_ports {led_io[3]}]
set_property BOARD_PIN {leds_8bits_tri_o_4} [get_ports {led_io[4]}]
set_property BOARD_PIN {leds_8bits_tri_o_5} [get_ports {led_io[5]}]
set_property BOARD_PIN {leds_8bits_tri_o_6} [get_ports {led_io[6]}]
set_property BOARD_PIN {leds_8bits_tri_o_7} [get_ports {led_io[7]}]

# Pin Mapping of DIP Switches
set_property BOARD_PIN {dip_switches_tri_i_0} [get_ports {dip_sw_io[0]}]
set_property BOARD_PIN {dip_switches_tri_i_1} [get_ports {dip_sw_io[1]}]
set_property BOARD_PIN {dip_switches_tri_i_2} [get_ports {dip_sw_io[2]}]
set_property BOARD_PIN {dip_switches_tri_i_3} [get_ports {dip_sw_io[3]}]
set_property BOARD_PIN {dip_switches_tri_i_4} [get_ports {dip_sw_io[4]}]
set_property BOARD_PIN {dip_switches_tri_i_5} [get_ports {dip_sw_io[5]}]
set_property BOARD_PIN {dip_switches_tri_i_6} [get_ports {dip_sw_io[6]}]
set_property BOARD_PIN {dip_switches_tri_i_7} [get_ports {dip_sw_io[7]}]

# Pin Mapping of LCD
set_property BOARD_PIN {lcd_7bits_tri_o_0} [get_ports {lcd_io[0]}]
set_property BOARD_PIN {lcd_7bits_tri_o_1} [get_ports {lcd_io[1]}]
set_property BOARD_PIN {lcd_7bits_tri_o_2} [get_ports {lcd_io[2]}]
set_property BOARD_PIN {lcd_7bits_tri_o_3} [get_ports {lcd_io[3]}]
set_property BOARD_PIN {lcd_7bits_tri_o_4} [get_ports {lcd_io[4]}]
set_property BOARD_PIN {lcd_7bits_tri_o_5} [get_ports {lcd_io[5]}]
set_property BOARD_PIN {lcd_7bits_tri_o_6} [get_ports {lcd_io[6]}]

# Pin Mapping of SD Card (Manual)
set_property -dict {PACKAGE_PIN AN30 IOSTANDARD LVCMOS18} [get_ports sdio_clk]
set_property -dict {PACKAGE_PIN AT30 IOSTANDARD LVCMOS18} [get_ports sdio_cd_dat3]
set_property -dict {PACKAGE_PIN AR30 IOSTANDARD LVCMOS18} [get_ports sdio_dat0]
set_property -dict {PACKAGE_PIN AP30 IOSTANDARD LVCMOS18} [get_ports sdio_cmd]

# Pin Mapping of BPI Flash
set_property BOARD_PIN {linear_flash_addr_1}  [get_ports {linear_flash_addr[0]}  ]
set_property BOARD_PIN {linear_flash_addr_2}  [get_ports {linear_flash_addr[1]}  ]
set_property BOARD_PIN {linear_flash_addr_3}  [get_ports {linear_flash_addr[2]}  ]
set_property BOARD_PIN {linear_flash_addr_4}  [get_ports {linear_flash_addr[3]}  ]
set_property BOARD_PIN {linear_flash_addr_5}  [get_ports {linear_flash_addr[4]}  ]
set_property BOARD_PIN {linear_flash_addr_6}  [get_ports {linear_flash_addr[5]}  ]
set_property BOARD_PIN {linear_flash_addr_7}  [get_ports {linear_flash_addr[6]}  ]
set_property BOARD_PIN {linear_flash_addr_8}  [get_ports {linear_flash_addr[7]}  ]
set_property BOARD_PIN {linear_flash_addr_9}  [get_ports {linear_flash_addr[8]}  ]
set_property BOARD_PIN {linear_flash_addr_10} [get_ports {linear_flash_addr[9]}  ]
set_property BOARD_PIN {linear_flash_addr_11} [get_ports {linear_flash_addr[10]} ]
set_property BOARD_PIN {linear_flash_addr_12} [get_ports {linear_flash_addr[11]} ]
set_property BOARD_PIN {linear_flash_addr_13} [get_ports {linear_flash_addr[12]} ]
set_property BOARD_PIN {linear_flash_addr_14} [get_ports {linear_flash_addr[13]} ]
set_property BOARD_PIN {linear_flash_addr_15} [get_ports {linear_flash_addr[14]} ]
set_property BOARD_PIN {linear_flash_addr_16} [get_ports {linear_flash_addr[15]} ]
set_property BOARD_PIN {linear_flash_addr_17} [get_ports {linear_flash_addr[16]} ]
set_property BOARD_PIN {linear_flash_addr_18} [get_ports {linear_flash_addr[17]} ]
set_property BOARD_PIN {linear_flash_addr_19} [get_ports {linear_flash_addr[18]} ]
set_property BOARD_PIN {linear_flash_addr_20} [get_ports {linear_flash_addr[19]} ]
set_property BOARD_PIN {linear_flash_addr_21} [get_ports {linear_flash_addr[20]} ]
set_property BOARD_PIN {linear_flash_addr_22} [get_ports {linear_flash_addr[21]} ]
set_property BOARD_PIN {linear_flash_addr_23} [get_ports {linear_flash_addr[22]} ]
set_property BOARD_PIN {linear_flash_addr_24} [get_ports {linear_flash_addr[23]} ]
set_property BOARD_PIN {linear_flash_addr_25} [get_ports {linear_flash_addr[24]} ]
set_property BOARD_PIN {linear_flash_addr_26} [get_ports {linear_flash_addr[25]} ]
set_property BOARD_PIN {linear_flash_adv_ldn} [get_ports  linear_flash_adv_ldn   ]
set_property BOARD_PIN {linear_flash_ce_n}    [get_ports  linear_flash_ce_n      ]
set_property BOARD_PIN {linear_flash_dq_i_0}  [get_ports {linear_flash_dq_io[0]} ]
set_property BOARD_PIN {linear_flash_dq_i_1}  [get_ports {linear_flash_dq_io[1]} ]
set_property BOARD_PIN {linear_flash_dq_i_2}  [get_ports {linear_flash_dq_io[2]} ]
set_property BOARD_PIN {linear_flash_dq_i_3}  [get_ports {linear_flash_dq_io[3]} ]
set_property BOARD_PIN {linear_flash_dq_i_4}  [get_ports {linear_flash_dq_io[4]} ]
set_property BOARD_PIN {linear_flash_dq_i_5}  [get_ports {linear_flash_dq_io[5]} ]
set_property BOARD_PIN {linear_flash_dq_i_6}  [get_ports {linear_flash_dq_io[6]} ]
set_property BOARD_PIN {linear_flash_dq_i_7}  [get_ports {linear_flash_dq_io[7]} ]
set_property BOARD_PIN {linear_flash_dq_i_8}  [get_ports {linear_flash_dq_io[8]} ]
set_property BOARD_PIN {linear_flash_dq_i_9}  [get_ports {linear_flash_dq_io[9]} ]
set_property BOARD_PIN {linear_flash_dq_i_10} [get_ports {linear_flash_dq_io[10]}]
set_property BOARD_PIN {linear_flash_dq_i_11} [get_ports {linear_flash_dq_io[11]}]
set_property BOARD_PIN {linear_flash_dq_i_12} [get_ports {linear_flash_dq_io[12]}]
set_property BOARD_PIN {linear_flash_dq_i_13} [get_ports {linear_flash_dq_io[13]}]
set_property BOARD_PIN {linear_flash_dq_i_14} [get_ports {linear_flash_dq_io[14]}]
set_property BOARD_PIN {linear_flash_dq_i_15} [get_ports {linear_flash_dq_io[15]}]
set_property BOARD_PIN {linear_flash_oen}     [get_ports  linear_flash_oen       ]
set_property BOARD_PIN {linear_flash_wen}     [get_ports  linear_flash_wen       ]

#Pin Mapping for FAN PWM
set_property -dict {PACKAGE_PIN BA37 IOSTANDARD LVCMOS18} [get_ports fan_pwm]
