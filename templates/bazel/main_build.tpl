load("@rules_hdl//verilog:defs.bzl", "verilog_library")
#load("@rules_hdl//verilator:defs.bzl", "verilator_cc_binary", "verilator_run")
load("@rules_hdl//dsim:defs.bzl", "dsim_run")

verilog_library(
    name = "tb",
    srcs = [
        "tb.sv",
    ],
    deps = [
        "@uvmdvgen//top_pkg:top_pkg",
        "@uvmdvgen//bus_params_pkg:bus_params_pkg",
        "@uvmdvgen//str_utils:str_utils",
        "@uvmdvgen//dv_utils:dv_utils",
        "@uvmdvgen//prim_assert:prim_assert",
        "@uvmdvgen//prim_mubi:prim_mubi",
        "@uvmdvgen//dv_base_reg:dv_base_reg",
        "@uvmdvgen//csr_utils:csr_utils",
        "@uvmdvgen//dv_lib:dv_lib",
        "@uvmdvgen//common_ifs:common_ifs",
        "//${bzl_relative_dir}/${name}_agent:${name}_agent",
        "//${bzl_relative_dir}/dv/env:env",
        "//${bzl_relative_dir}/dv/tests:${name}_tests",
        "//${bzl_relative_dir}/dv/tests/seq_lib:${name}_tests_seq_lib",
        "//hw/ip/hif_adapter/rtl:hif_adapter",
    ],
)

dsim_run(
    name = "tb_run",
    dsim_env = "//util/env:dsim_env.sh",
    module = ":tb",
    module_top = "tb",
    enable_code_coverage = True,
    code_coverage_scope = "tb.dut",
    code_coverage_report = True,
    opts = [
        "-uvm", "1.2",
        "+define+UVM",
        "+UVM_TESTNAME=${name}_base_test",
        "+UVM_TEST_SEQ=${name}_smoke_vseq",
    ],
)

