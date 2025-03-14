load("@buildifier_prebuilt//:rules.bzl", "buildifier")
load("@rules_hdl//verilog:defs.bzl", "verilog_library")

package(
    default_visibility = ["//visibility:public"],
    licenses = ["notice"],
)

buildifier(
    name = "buildifier",
    add_tables = "//:buildifier_cfg.json",
    exclude_patterns = [
        "./.git/*",
    ],
    lint_mode = "fix",
)

verilog_library(
    name = "dv_lib",
    visibility = ["//visibility:public"],
    deps = [
        "//top_pkg",
        "//bus_params_pkg",
        "//str_utils",
        "//dv_utils",
        "//prim_assert",
        "//prim_mubi",
        "//dv_base_reg",
        "//csr_utils",
        "//dv_lib",
        "//common_ifs",
    ],
)
