load("@rules_hdl//verilog:defs.bzl", "verilog_library")

verilog_library(
    name = "${name}_tests",
    srcs = [
        "${name}_test_pkg.sv",
    ],
    hdrs = [
        "${name}_base_test.svh",
    ],
    visibility = ["//visibility:public"],
)

