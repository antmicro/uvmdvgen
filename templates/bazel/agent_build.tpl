load("@rules_hdl//verilog:defs.bzl", "verilog_library")

verilog_library(
    name = "${name}_agent",
    srcs = [
        "${name}_agent_pkg.sv",
        "${name}_if.sv",
    ],
    hdrs = [
        "${name}_agent_cfg.svh",
        "${name}_agent_cov.svh",
        "${name}_driver.svh",
        "${name}_monitor.svh",
        "${name}_agent.svh",
        "${name}_item.svh",
        "seq_lib/${name}_base_seq.svh",
        "seq_lib/${name}_seq_list.svh",
    ],
    visibility = ["//visibility:public"],
)

