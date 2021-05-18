############################################################################
## @project       Object Detection & Tracking Uint(ODTU)
## @filename      odtu.xdc
## @author        3book
## @description   Constraints file
## @created       2019-08-15T15:31:46.203Z+08:00
## @copyright     Copyright (c) 2019 tbi-t
## @last-modified 2021-05-18T15:27:34.016Z+08:00
# system Clock constraints                                                        #

#create_clock -name clk_100m -period 10.000 -waveform {0.000 5.000} [get_ports clk_100m]
#set_input_jitter clk_100m 0.600
#create_clock -period 6.734 -name gt_refclk_p -waveform {0.000 3.367} [get_ports gt_refclk_p]
#The clocks are asynchronous, user should constrain them appropriately.#
#set_false_path -from clk_100m -to [get_clocks -include_generated_clocks -of_objects [get_pins -hier -filter name=~*gt0_gtwizard_0_i*gtxe2_i*RXOUTCLK]]
