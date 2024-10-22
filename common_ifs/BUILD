load("@rules_hdl//verilog:defs.bzl", "verilog_library")

verilog_library(
    name = "common_ifs",
    srcs = [
        "common_ifs_pkg.sv",
        "entropy_subsys_fifo_exception_pkg.sv",
        "clk_rst_if.sv",
        "clk_if.sv",
        "entropy_subsys_fifo_exception_if.sv",
        "rst_shadowed_if.sv",
        "pins_if.sv",
    ],
    visibility = ["//visibility:public"],
)
