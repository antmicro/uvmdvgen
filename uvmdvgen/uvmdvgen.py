#!/usr/bin/env python3
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
r"""Command-line tool to generate boilerplate DV testbench.

The generated objects are extended from dv_lib.
"""
import argparse
import logging as log
import re
import sys
from pathlib import Path
from importlib.resources import files
import shutil

import uvmdvgen
from uvmdvgen import gen_agent
from uvmdvgen import gen_env
from uvmdvgen import gen_bench
from uvmdvgen import gen_dotf


def main():
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument(
        "--init-workspace",
        help="Initialize workspace in a given directory and end the script",
    )
    parser.add_argument(
        "name",
        metavar="[ip/block name]",
        help="""Name of the ip/block for which the UVM TB is being generated.
                This should just name the block, not the path to it.""",
        nargs="?",
        default=None)

    parser.add_argument(
        "-a",
        "--gen-agent",
        action='store_true',
        help="Generate UVM agent code extended from DV library")

    parser.add_argument(
        "-s",
        "--has-separate-host-device-driver",
        action='store_true',
        help="""IP / block agent creates a separate driver for host and device modes.
        (Ignored if -a switch is not passed.)""")

    parser.add_argument("-e",
                        "--gen-env",
                        action='store_true',
                        help="Generate UVM environment code")

    parser.add_argument(
        "-c",
        "--is-cip",
        action='store_true',
        help=
        """Is comportable IP - this will result in code being extended from CIP
        library. If switch is not passed, the code will be extended from DV
        library instead. (Ignored if -e switch is not passed.)""")

    parser.add_argument(
        "-hr",
        "--has-ral",
        default=False,
        action='store_true',
        help="""Specify whether the DUT has CSRs and thus needs a UVM RAL model.
             """)

    parser.add_argument(
        "-hi",
        "--has-interrupts",
        default=False,
        action='store_true',
        help="""CIP has interrupts. Create interrupts interface in tb""")

    parser.add_argument(
        "-ha",
        "--has-alerts",
        default=False,
        action='store_true',
        help="""CIP has alerts. Create alerts interface in tb""")

    parser.add_argument(
        "-ne",
        "--num-edn",
        default=0,
        type=int,
        help="""CIP has EDN connection. Create edn pull interface in tb""")

    parser.add_argument(
        "-ea",
        "--env-agents",
        nargs="+",
        metavar="agt1 agt2",
        help="""Env/bench create an interface agent specified here. They are
                assumed to already exist. Note that the list is space-separated,
                and not comma-separated. (ignored if -e switch is not passed)"""
    )

    parser.add_argument("-b",
                        "--gen-bench",
                        action='store_true',
                        help="Generate UVM testbench code")

    parser.add_argument(
        "-ao",
        "--agent-outdir",
        metavar="[hw/dv/sv]",
        help="""Path to place the agent code. A directory called <name>_agent is
                created at this location. (default set to './<name>')""")

    parser.add_argument(
        "-eo",
        "--env-outdir",
        metavar="[hw/ip/<ip>]",
        help="""Path to place the enviroment code. It creates dv/env directory
        with environment sources. (default set to './<name>'.)""")

    parser.add_argument(
        "-bo",
        "--bench-outdir",
        metavar="[hw/ip/<ip>]",
        help="""Path to place the testbench code. It creates dv directory.
        Under dv, it creates 3 sub-directories - cov, sva, and
        tests and tb.sv file. (default set to './<name>'.)""")

    parser.add_argument(
        "-v",
        "--vendor",
        default="",
        help="""Name of the vendor / entity developing the testbench. This is used
        to set the VLNV of the FuseSoC core files.""")

    parser.add_argument(
        "-fsoc",
        "--fusesoc",
        action='store_true',
        help="""Enable FuseSoC core files generation.""")

    parser.add_argument(
        "-bzl",
        "--bazel",
        action='store_true',
        help="""Enable Bazel BUILD files generation.""")

    parser.add_argument(
        '--workspace-root',
        required='-bzl' in sys.argv or '--bazel' in sys.argv,
        help="""Path to the root of the workspace (generated with "uvmdvgen init" command)""")

    parser.add_argument(
        '--use-svh',
        help="Tells whether to mark header files with svh extension or keep sv extension",
        action="store_true"
    )

    parser.add_argument(
        '--license-header-file',
        help="Provides path to the file with the content of the license header for files",
        type=Path
    )

    parser.add_argument(
        '--default-timescale',
        help="Provide a default timescale that will be added to SV files, e.g. `1ns/1ps`",
        default="",
    )

    parser.add_argument(
        '--seq-lib-location',
        help="Location of the seq_lib library",
        choices=["tests", "env"],
        default="tests",
    )

    parser.add_argument(
        "-ld",
        "--link-dependencies",
        action='store_true')

    parser.add_argument(
        "-d",
        "--dependency-root-dir",
        default="",
        required='-ld' in sys.argv or '--link-dependencies' in sys.argv)

    args = parser.parse_args()

    if args.init_workspace:
        shutil.copytree(files(uvmdvgen) / "uvm_dv_lib", args.init_workspace)
        sys.exit(0)

    if args.name is None:
        log.error("name argument is not provided")
        sys.exit(1)

    # The name should be alphanumeric.
    if re.search(r"\W", args.name):
        log.error("The block name '%s' contains non-alphanumeric characters.",
                  args.name)
        sys.exit(1)

    if not args.agent_outdir:
        args.agent_outdir = args.name
    if not args.env_outdir:
        args.env_outdir = args.name
    if not args.bench_outdir:
        args.bench_outdir = args.name
    if not args.workspace_root:
        args.workspace_root = ""
    if not args.link_dependencies or not args.dependency_root_dir:
        args.dependency_root_dir = ""

    license_header = ""

    if args.license_header_file:
        with args.license_header_file.open() as license_file:
            license_header = license_file.readlines()

    if args.gen_agent:
        gen_agent.gen_agent(
            name=args.name,
            has_separate_host_device_driver=args.has_separate_host_device_driver,
            root_dir=args.agent_outdir,
            vendor=args.vendor,
            license_header=license_header,
            gen_core_file=args.fusesoc,
            gen_bazel_file=args.bazel,
            use_svh=args.use_svh,
            default_timescale=args.default_timescale
        )

    if args.gen_env:
        if not args.env_agents:
            args.env_agents = []
        gen_env.gen_env(
            name=args.name,
            has_ral=args.has_ral,
            env_agents=args.env_agents,
            root_dir=args.env_outdir,
            vendor=args.vendor,
            license_header=license_header,
            gen_core_file=args.fusesoc,
            gen_bazel_file=args.bazel,
            use_svh=args.use_svh,
            default_timescale=args.default_timescale,
            is_cip=args.is_cip,
            has_alerts=args.has_alerts,
            has_interrupts=args.has_interrupts,
        )

    if args.gen_bench:
        if not args.env_agents:
            args.env_agents = []
        gen_bench.gen_bench(
            name=args.name,
            has_ral=args.has_ral,
            env_agents=args.env_agents,
            root_dir=args.bench_outdir,
            vendor=args.vendor,
            bazel_root=args.workspace_root,
            license_header=license_header,
            gen_core_file=args.fusesoc,
            gen_bazel_file=args.bazel,
            use_svh=args.use_svh,
            default_timescale=args.default_timescale,
            is_cip=args.is_cip,
            has_alerts=args.has_alerts,
            has_interrupts=args.has_interrupts,
            num_edn=args.num_edn,
            seq_lib_location=args.seq_lib_location,
        )
        gen_dotf.generate_dotf(
            name=args.name,
            bazel_root=args.workspace_root,
            rootdir=Path(args.bench_outdir),
            out_dir=Path(args.bench_outdir) / 'dv/tb.f',
            link_dependencies=args.dependency_root_dir
        )

if __name__ == '__main__':
    main()
