load("@buildifier_prebuilt//:rules.bzl", "buildifier")

package(
    default_visibility = ["//visibility:public"],
    licenses = ["notice"],
)

buildifier(
    name = "buildifier",
    exclude_patterns = [
        "./.git/*",
    ],
    lint_mode = "fix",
)
