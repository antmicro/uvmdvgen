% if link_dependencies:
# The order of inclusions here is crucial
+incdir+${link_dependencies}/*
${link_dependencies}/top_pkg/top_pkg.sv
${link_dependencies}/bus_params_pkg/bus_params_pkg.sv
${link_dependencies}/str_utils/str_utils_pkg.sv
${link_dependencies}/dv_utils/dv_test_status_pkg.sv
${link_dependencies}/dv_utils/dv_report_server.sv
${link_dependencies}/dv_utils/dv_utils_pkg.sv
${link_dependencies}/prim_mubi/prim_mubi_pkg.sv
${link_dependencies}/dv_base_reg/dv_base_reg_pkg.sv
${link_dependencies}/csr_utils/csr_utils_pkg.sv
${link_dependencies}/dv_lib/dv_lib_pkg.sv
${link_dependencies}/common_ifs/common_ifs_pkg.sv
${link_dependencies}/common_ifs/clk_rst_if.sv
${link_dependencies}/common_ifs/clk_if.sv
% endif
% if bazel_root:

${bazel_root}/hw/ip/${name}/rtl/${name}.sv
% endif

# dot-f Files
% for file in f_files:
-F ${file}
% endfor
