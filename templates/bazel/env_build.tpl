load("@rules_hdl//verilog:defs.bzl", "verilog_library")

verilog_library(
    name = "env",
    srcs = [
        "${name}_env_pkg.sv",
    ],
    hdrs = [
        "${name}_scoreboard.svh",
        "${name}_env_cov.svh",
        "${name}_env.svh",
        "${name}_virtual_sequencer.svh",
        "${name}_env_cfg.svh",
    ],
    visibility = ["//visibility:public"],
)

