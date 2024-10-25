load("@umvmdvgen_pip_deps//:requirements.bzl", "requirement")

package(
    default_visibility = ["//visibility:public"],
    licenses = ["notice"],
)

py_library(
    name = "gen_agent",
    srcs = ["gen_agent.py"],
    data = [
        "//templates:agent_templates",
        "//templates:bazel_templates",
        "//templates:fusesoc_templates",
    ],
    srcs_version = "PY3ONLY",
    deps = [
        requirement("mako"),
        requirement("importlib_resources"),
    ],
)

py_library(
    name = "gen_env",
    srcs = ["gen_env.py"],
    data = [
        "//templates:env_templates",
        "//templates:bazel_templates",
        "//templates:fusesoc_templates",
    ],
    srcs_version = "PY3ONLY",
    deps = [
        requirement("mako"),
        requirement("importlib_resources"),
    ],
)

py_library(
    name = "gen_dotf",
    srcs = ["gen_dotf.py"],
    srcs_version = "PY3ONLY",
    deps = [
        requirement("mako"),
        requirement("importlib_resources"),
    ],
    data = [
        "//templates:bench_templates",
        "//templates:env_templates",
        "//templates:bazel_templates",
        "//templates:fusesoc_templates"
    ]
)

py_library(
    name = "gen_bench",
    srcs = ["gen_bench.py"],
    data = [
        "//templates:bench_templates",
        "//templates:bazel_templates",
        "//templates:fusesoc_templates",
    ],
    srcs_version = "PY3ONLY",
    deps = [
        requirement("mako"),
        requirement("importlib_resources"),
    ],
)

py_binary(
    name = "uvmdvgen",
    srcs = ["uvmdvgen.py"],
    srcs_version = "PY3ONLY",
    deps = [
        ":gen_agent",
        ":gen_bench",
        ":gen_env",
        ":gen_dotf"
    ],
)
