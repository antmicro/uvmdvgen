load("@rules_hdl//verilog:defs.bzl", "verilog_library")

verilog_library(
    name = "dv_utils",
    srcs = [
        "dv_test_status_pkg.sv",
        "dv_utils_pkg.sv",
        "dv_report_server.sv",
        "dv_vif_wrap.sv",
        "dv_report_catcher.sv",
    ],
    hdrs = [
        "dv_macros.svh",
        "dv_fcov_macros.svh",
    ],
    visibility = ["//visibility:public"],
)
