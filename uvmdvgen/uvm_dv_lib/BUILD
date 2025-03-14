load("@buildifier_prebuilt//:rules.bzl", "buildifier")

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
