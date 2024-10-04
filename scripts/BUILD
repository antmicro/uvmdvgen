load("@umvmdvgen_pip_deps//:requirements.bzl", "requirement")

package(
    default_visibility = ["//visibility:public"],
    licenses = ["notice"],
)

py_library(
    name = "gen_agent",
    srcs = ["gen_agent.py"],
    srcs_version = "PY3ONLY",
    deps = [
        requirement("mako"),
        requirement("importlib_resources"),
    ],
    data = [
        "//templates:agent_templates",
        "//templates:fusesoc_templates",
    ]
)

py_library(
    name = "gen_env",
    srcs = ["gen_env.py"],
    srcs_version = "PY3ONLY",
    deps = [
        requirement("mako"),
        requirement("importlib_resources"),
    ],
    data = [
        "//templates:env_templates",
        "//templates:fusesoc_templates"
    ]
)

py_library(
    name = "gen_bench",
    srcs = ["gen_bench.py"],
    srcs_version = "PY3ONLY",
    deps = [
        requirement("mako"),
        requirement("importlib_resources"),
    ],
    data = [
        "//templates:bench_templates",
        "//templates:fusesoc_templates"
    ]
)

py_binary(
    name = "uvmdvgen",
    srcs = ["uvmdvgen.py"],
    srcs_version = "PY3ONLY",
    deps = [
        ":gen_agent",
        ":gen_env",
        ":gen_bench"
    ],
)
