set con_files              "../exercise_02/results/$toplevel.synth.sdc"

set max_timing_lib         [list "$TSMC_DIR/digital/Front_End/timing_power_noise/NLDM/tcbn65lp_200a/tcbn65lpwc.lib" \
"$TSMC_DIR/digital/Front_End/timing_power_noise/NLDM/tpan65lpnv2_140b/tpan65lpnv2wc.lib" \
"$TSMC_DIR/digital/Front_End/timing_power_noise/NLDM/tpdn65lpnv2_140b/tpdn65lpnv2wc.lib" \
"../../units/analog_top/abstract/analog_top_tb_SRAM_top.lib" \
"../../units/analog_top/abstract/analog_top_tb_cap_mem_top.lib" \
"../../units/analog_top/abstract/analog_top_tb_syn_dac_top.lib" \
"../../units/generic_elements/abstract/esd_PDB1AC_lr.lib" \
"../../units/generic_elements/abstract/esd_PDB1A_lr.lib" \
"../../units/generic_elements/abstract/esd_PDB1A_hr.lib" \
"../../units/generic_elements/abstract/esd_PDB3AC_lr.lib" \
"../../units/generic_elements/abstract/esd_PDB3A_lr.lib" \
"../../units/generic_elements/abstract/esd_PDB3A_hr.lib"]

set typ_timing_lib         [list "$TSMC_DIR/digital/Front_End/timing_power_noise/NLDM/tcbn65lp_200a/tcbn65lptc.lib" \
"$TSMC_DIR/digital/Front_End/timing_power_noise/NLDM/tpan65lpnv2_140b/tpan65lpnv2tc.lib" \
"$TSMC_DIR/digital/Front_End/timing_power_noise/NLDM/tpdn65lpnv2_140b/tpdn65lpnv2tc.lib" \
"../../units/analog_top/abstract/analog_top_tb_SRAM_top.lib" \
"../../units/analog_top/abstract/analog_top_tb_cap_mem_top.lib" \
"../../units/analog_top/abstract/analog_top_tb_syn_dac_top.lib" \
"../../units/generic_elements/abstract/esd_PDB1AC_lr.lib" \
"../../units/generic_elements/abstract/esd_PDB1A_lr.lib" \
"../../units/generic_elements/abstract/esd_PDB1A_hr.lib" \
"../../units/generic_elements/abstract/esd_PDB3AC_lr.lib" \
"../../units/generic_elements/abstract/esd_PDB3A_lr.lib" \
"../../units/generic_elements/abstract/esd_PDB3A_hr.lib"]

set min_timing_lib         [list "$TSMC_DIR/digital/Front_End/timing_power_noise/NLDM/tcbn65lp_200a/tcbn65lpbc.lib" \
"$TSMC_DIR/digital/Front_End/timing_power_noise/NLDM/tpan65lpnv2_140b/tpan65lpnv2bc.lib" \
"$TSMC_DIR/digital/Front_End/timing_power_noise/NLDM/tpdn65lpnv2_140b/tpdn65lpnv2bc.lib" \
"../../units/analog_top/abstract/analog_top_tb_SRAM_top.lib" \
"../../units/analog_top/abstract/analog_top_tb_cap_mem_top.lib" \
"../../units/analog_top/abstract/analog_top_tb_syn_dac_top.lib" \
"../../units/generic_elements/abstract/esd_PDB1AC_lr.lib" \
"../../units/generic_elements/abstract/esd_PDB1A_lr.lib" \
"../../units/generic_elements/abstract/esd_PDB1A_hr.lib" \
"../../units/generic_elements/abstract/esd_PDB3AC_lr.lib" \
"../../units/generic_elements/abstract/esd_PDB3A_lr.lib" \
"../../units/generic_elements/abstract/esd_PDB3A_hr.lib"]

# best case transitors with 1.32V core at 125°C 
set min_timing_lib_1v32_125 [lreplace $min_timing_lib 0 2 \
"$TSMC_DIR/digital/Front_End/timing_power_noise/NLDM/tcbn65lp_200a/tcbn65lpml.lib" \
"$TSMC_DIR/digital/Front_End/timing_power_noise/NLDM/tpan65lpnv2_140b/tpan65lpnv2ml.lib" \
"$TSMC_DIR/digital/Front_End/timing_power_noise/NLDM/tpdn65lpnv2_140b/tpdn65lpnv2ml.lib" \
]

# best case transitors with 1.32V core at -40°C 
set min_timing_lib_1v32_m40 [lreplace $min_timing_lib 0 2 \
"$TSMC_DIR/digital/Front_End/timing_power_noise/NLDM/tcbn65lp_200a/tcbn65lplt.lib" \
"$TSMC_DIR/digital/Front_End/timing_power_noise/NLDM/tpan65lpnv2_140b/tpan65lpnv2lt.lib" \
"$TSMC_DIR/digital/Front_End/timing_power_noise/NLDM/tpdn65lpnv2_140b/tpdn65lpnv2lt.lib" \
]

set hold_libsets [list $min_timing_lib $min_timing_lib_1v32_125 $min_timing_lib_1v32_m40]
set hold_libs    [list "tcbn65lpbc" "tcbn65lpml" "tcbn65lplt"]
set hold_opconds [list "BCCOM" "MLCOM" "LTCOM"]
set hold_temps   [list 0 125 -40]
set hold_vdds    [list 1.32 1.32 1.32]

###################################################################################################

set cap_table_typ          "$TSMC_DIR/encounter/captbl/tsmc_crn65lp_1p09m+alrdl_6x1z1u_typ_extended.captbl"
set cap_table_max          "$TSMC_DIR/encounter/captbl/tsmc_crn65lp_1p09m+alrdl_6x1z1u_typ_extended.captbl"
set cap_table_min          "$TSMC_DIR/encounter/captbl/tsmc_crn65lp_1p09m+alrdl_6x1z1u_typ_extended.captbl"

#
# CeltIC Setup
#
set max_noise_lib          ""

set typ_noise_lib          ""

set min_noise_lib          ""

set noise_process          "65"

#
# Fire and Ice Setup
#
set qx_tech_file_rctyp         "$TSMC_DIR/imec_online/CMN65LP/t-n65-cm-sp-007-v1_1_3a/1p9m_6x1z1u/typical/qrcTechFile"
set qx_tech_file_rcworst       "$TSMC_DIR/imec_online/CMN65LP/t-n65-cm-sp-007-v1_1_3a/1p9m_6x1z1u/rcworst/qrcTechFile"
set qx_tech_file_rcbest        "$TSMC_DIR/imec_online/CMN65LP/t-n65-cm-sp-007-v1_1_3a/1p9m_6x1z1u/rcbest/qrcTechFile"
set qx_tech_file_rworst        "$TSMC_DIR/imec_online/CMN65LP/t-n65-cm-sp-007-v1_1_3a/1p9m_6x1z1u/rworst/qrcTechFile"
set qx_tech_file_rbest         "$TSMC_DIR/imec_online/CMN65LP/t-n65-cm-sp-007-v1_1_3a/1p9m_6x1z1u/rbest/qrcTechFile"
set qx_leflayer_map            "../lef_layermap.txt"


########################################

# create one worst corner
create_library_set \
    -name WORST_LIBSET \
    -timing $max_timing_lib

create_rc_corner \
    -name RCWORST \
    -cap_table $cap_table_max \
    -T 125 \
    -qx_tech_file $qx_tech_file_rcworst

create_delay_corner \
    -name MAX_CORNER \
    -library_set WORST_LIBSET \
    -opcond_library tcbn65lpwc \
    -opcond WCCOM \
    -rc_corner RCWORST

########################################
# create three best hold corners
foreach libset $hold_libsets temp $hold_temps vdd $hold_vdds lib $hold_libs opcond $hold_opconds {
	puts $libset
	create_library_set \
	  -name BEST_LIBSET_${vdd}_${temp} \
	  -timing $libset

	create_rc_corner \
	  -name RCBEST_${vdd}_${temp} \
	  -cap_table $cap_table_min \
	  -T $temp \
	  -qx_tech_file $qx_tech_file_rcbest

	create_delay_corner \
	  -name MIN_CORNER_${vdd}_${temp} \
	  -library_set BEST_LIBSET_${vdd}_${temp} \
	  -opcond_library $lib \
	  -opcond $opcond \
	  -rc_corner RCBEST_${vdd}_${temp}
}


########################################
# create one typical corner
create_library_set \
    -name TYP_LIBSET \
        -timing $typ_timing_lib

create_rc_corner \
    -name RCTYP \
    -cap_table $cap_table_typ \
    -T 27 \
    -qx_tech_file $qx_tech_file_rctyp

create_delay_corner \
    -name TYP_CORNER \
    -library_set TYP_LIBSET \
    -opcond_library tcbn65lptc \
    -opcond NCCOM \
    -rc_corner RCTYP


########################################

create_constraint_mode \
    -name missionSetup \
    -sdc_files $con_files

########################################

create_analysis_view \
    -name missionSlow \
    -delay_corner MAX_CORNER \
    -constraint_mode missionSetup

create_analysis_view \
    -name missionTyp \
    -delay_corner TYP_CORNER \
    -constraint_mode missionSetup

set hold_views []
foreach temp $hold_temps vdd $hold_vdds {
	create_analysis_view \
	  -name missionFast_${vdd}_${temp} \
	  -delay_corner MIN_CORNER_${vdd}_${temp} \
	  -constraint_mode missionSetup
	lappend hold_views missionFast_${vdd}_${temp}
}


########################################

set_analysis_view \
    -setup {missionSlow missionTyp} \
    -hold {missionFast_1.32_0 missionTyp}

########################################
