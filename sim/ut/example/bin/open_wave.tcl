load_feature simulator
open_wave_database {tb_top.wdb}

add_wave_divider TB_TOP
add_wave {{/tb_top}} 

add_wave_divider DUT
add_wave {{/tb_top/DUT}} 
#current_fileset
#open_wave_database tb_top.wdb
