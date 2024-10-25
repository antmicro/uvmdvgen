load("@buildifier_prebuilt//:rules.bzl", "buildifier")
load("@rules_python//python:pip.bzl", "compile_pip_requirements")

package(
    default_visibility = ["//visibility:public"],
    licenses = ["notice"],
)

compile_pip_requirements(
    name = "python_requirements",
    src = "python-requirements.in",
    extra_args = ["--strip-extras"],
    requirements_txt = "python-requirements.out",
)

buildifier(
    name = "buildifier",
    exclude_patterns = [
        "./.git/*",
    ],
    lint_mode = "fix",
)
