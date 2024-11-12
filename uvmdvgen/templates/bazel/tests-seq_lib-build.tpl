load("@rules_hdl//verilog:defs.bzl", "verilog_library")

verilog_library(
    name = "${name}_tests_seq_lib",
    hdrs = [
        "${name}_base_vseq.svh",
        "${name}_common_vseq.svh",
        "${name}_smoke_vseq.svh",
        "${name}_vseq_list.svh",
    ],
    visibility = ["//visibility:public"],
)

