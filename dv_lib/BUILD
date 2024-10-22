load("@rules_hdl//verilog:defs.bzl", "verilog_library")

verilog_library(
    name = "dv_lib",
    srcs = [
        "dv_lib_pkg.sv",
    ],
    hdrs = [
        "dv_base_agent.svh",
        "dv_base_env_cov.svh",
        "dv_base_sequencer.svh",
        "dv_base_vseq.svh",
        "dv_base_test.svh",
        "dv_base_driver.svh",
        "dv_base_monitor.svh",
        "dv_base_agent_cov.svh",
        "dv_base_seq.svh",
        "dv_base_env_cfg.svh",
        "dv_base_env.svh",
        "dv_base_agent_cfg.svh",
        "dv_base_virtual_sequencer.svh",
        "dv_base_scoreboard.svh",
    ],
    visibility = ["//visibility:public"],
)
