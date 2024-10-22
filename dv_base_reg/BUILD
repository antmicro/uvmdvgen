load("@rules_hdl//verilog:defs.bzl", "verilog_library")

verilog_library(
    name = "dv_base_reg",
    srcs = [
        "dv_base_reg_pkg.sv",
    ],
    hdrs = [
        "csr_excl_item.svh",
        "dv_base_lockable_field_cov.svh",
        "dv_base_shadowed_field_cov.svh",
        "dv_base_mubi_cov.svh",
        "dv_base_reg_field.svh",
        "dv_base_reg.svh",
        "dv_base_mem.svh",
        "dv_base_reg_block.svh",
        "dv_base_reg_map.svh",
    ],
    visibility = ["//visibility:public"],
)
