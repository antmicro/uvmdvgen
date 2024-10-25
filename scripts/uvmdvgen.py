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

from scripts import gen_agent
from scripts import gen_env
from scripts import gen_bench
from scripts import gen_dotf

def main():
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument(
        "name",
        metavar="[ip/block name]",
        help="""Name of the ip/block for which the UVM TB is being generated.
                This should just name the block, not the path to it.""")

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
        "-hr",
        "--has-ral",
        default=False,
        action='store_true',
        help="""Specify whether the DUT has CSRs and thus needs a UVM RAL model.
             """)

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
        '-bzlroot',
        '--bazel-root',
        required='-bzl' in sys.argv or '--bazel' in sys.argv,
        help="""Path to the root of the bazel workspace (where the WORKSPACE file resides)""")

    parser.add_argument(
        "-ld",
        "--link-dependencies",
        action='store_true',
        help="""""")

    parser.add_argument(
        "-d",
        "--dependency-root-dir",
        default="",
        required='-ld' in sys.argv or '--link-dependencies' in sys.argv,
        help="""""")

    args = parser.parse_args()
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
    if not args.bazel_root:
        args.bazel_root = ""
    if not args.link_dependencies or not args.dependency_root_dir:
        args.dependency_root_dir = ""

    if args.gen_agent:
        gen_agent.gen_agent(args.name, args.has_separate_host_device_driver,
                            args.agent_outdir, args.vendor,
                            gen_core_file=args.fusesoc, gen_bazel_file=args.bazel)

    if args.gen_env:
        if not args.env_agents:
            args.env_agents = []
        gen_env.gen_env(args.name, args.has_ral, args.env_agents,
                        args.env_outdir, args.vendor,
                        gen_core_file=args.fusesoc, gen_bazel_file=args.bazel)

    if args.gen_bench:
        if not args.env_agents:
            args.env_agents = []
        gen_bench.gen_bench(args.name, args.has_ral, args.env_agents,
                            args.bench_outdir, args.vendor,
                            gen_core_file=args.fusesoc, gen_bazel_file=args.bazel_root)
        gen_dotf.generate_dotf(args.name, args.bazel_root, Path(args.bench_outdir),
                               Path(args.bench_outdir) / 'dv/tb.f', link_dependencies=args.dependency_root_dir)

if __name__ == '__main__':
    main()
