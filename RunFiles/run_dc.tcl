#################################
# 
# Define Variable
# 
#################################
#remove_design -all
set clock_name "UserCLK"
set clock_period 40
set RTL_PATH "../RTL_codes"
set REPORT_PATH "../DC/report"
set PreSim_PATH "../PreSim/netlist"
set Design LUT4AB


set_svf ${Design}.svf

#####################################################################
# 
# Read Design
# 
#####################################################################
saif_map -start

analyze -format verilog ${RTL_PATH}/LUT4AB_tile.v
analyze -format verilog ${RTL_PATH}/models_pack.v
analyze -format verilog ${RTL_PATH}/LUT4AB_ConfigMem.v
analyze -format verilog ${RTL_PATH}/LUT4AB_switch_matrix.v
analyze -format verilog ${RTL_PATH}/LUT4c_frame_config_dffesr.v
analyze -format verilog ${RTL_PATH}/MUX8LUT_frame_config_mux.v


elaborate $Design
#check_timing
set current_design LUT4AB
source ./LUT4AB.con

#################################
# 
# Saving Designs
# 
#################################
check_design
write -format ddc -hier -o $PreSim_PATH/${Design}_pre_dc.ddc

compile_ultra -incremental -only_design_rule 
compile -map_effort high -area_effort high -power_effort high -ungroup_all -boundary_optimization -auto_ungroup area
# compile -map_effort high  -area_effort high -power_effort high -ungroup_all -auto_ungroup delay -no_design_rule
# check_design

write -format ddc -hierarchy -output $PreSim_PATH/${Design}_mapped.ddc
write -format verilog -hier -o $PreSim_PATH/${Design}_dc.v
write_sdf $PreSim_PATH/${Design}_dc.sdf

# get report file
redirect -tee -file ${REPORT_PATH}/report_timing.txt {report_timing}
redirect -tee -file ${REPORT_PATH}/report_power.txt {report_power}
redirect -tee -file ${REPORT_PATH}/report_area.txt {report_area}
redirect -tee -file ${REPORT_PATH}/report_qor.txt {report_qor}
redirect -tee -file ${REPORT_PATH}/compile_ultra.txt {man compile_ultra}



