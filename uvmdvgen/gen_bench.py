# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
"""Generate SystemVerilog UVM agent extended freom our DV lib
"""

import os
import logging as log

from mako.template import Template
from importlib.resources import files
from uvmdvgen import templates
from pathlib import Path

def gen_bench(name, has_ral, env_agents, root_dir, vendor, bazel_root=".", license_header=[],
              gen_core_file=True, gen_bazel_file=False, use_svh=True, default_timescale="", is_cip=False, has_alerts=False, has_interrupts=False, num_edn=0, seq_lib_location="tests"):
    # yapf: disable
    # flake8: noqa
    # 4-tuple - sub-path, ip name, class name, file ext
    env_srcs = [(f'dv/{seq_lib_location}/seq_lib',  name + '_', 'base_vseq',           '.svh'),
                (f'dv/{seq_lib_location}/seq_lib',  name + '_', 'smoke_vseq',          '.svh'),
                (f'dv/{seq_lib_location}/seq_lib',  name + '_', 'common_vseq',         '.svh'),
                (f'dv/{seq_lib_location}/seq_lib',  name + '_', 'vseq_list',           '.svh'),
                ('dv/sva',            name + '_', 'bind',                '.sv'),
                ('dv/sva',            name + '_', 'sva',                 '.core'),
                ('dv/tests',          name + '_', 'base_test',           '.svh'),
                ('dv/tests',          name + '_', 'test_pkg',            '.sv'),
                ('dv/tests',          name + '_', 'test',                '.core'),
                ('dv/cov',            '',         '',                    ''),
                ('dv',                name + '_', 'sim_cfg',             '.hjson'),
                ('data',              name + '_', 'testplan',            '.hjson'),
                ('dv',                name + '_', 'sim',                 '.core'),
                ('dv',                ""        , 'main_build',          ''),
                ('dv',                ""        , 'tests-build',         ''),
                ('dv',                ""        , 'tests-seq_lib-build', ''),
                ('dv',                '',         'tb',                  '.sv'),
                ('dv',                name + '_', 'bench',               '.f')]
    # yapf: enable

    default_header_ext = "svh" if use_svh else "sv"

    src_dirs = []
    sv_files = []
    # skipping the last entry, as it is the dot-f file itself
    for i in env_srcs[:-1]:
        # if the extension is a sv source or header, compute the full source path
        # relative to the root agent directory, where the dot-f will be generated
        if i[3] == '.sv':
            sv_files.append(str((Path(i[0]) / (i[1] + i[2] + i[3])).relative_to("dv")))
    for i in env_srcs:
        if i[3] in ['.sv', '.svh', '.f', '.core']:
            # append string versions of the directory relative to the agent directory
            src_dirs.append(str('./' / Path(i[0]).relative_to("dv")))
    # Remove duplicates
    src_dirs = sorted(set(src_dirs))

    for tup in env_srcs:
        path_dir = root_dir + '/' + tup[0]
        src_prefix = tup[1]
        src = tup[2]
        src_suffix = tup[3]

        ftpl = src + src_suffix + '.tpl'
        header_ext = ".sv" if not use_svh and src_suffix == ".svh" else src_suffix
        file_name = src_prefix + src + header_ext

        bzl_relative_dir = ''

        if not os.path.exists(path_dir):
            os.system("mkdir -p " + path_dir)
        if file_name == "":
            continue

        # read template
        if not gen_core_file and src_suffix == ".core":
            continue
        elif not gen_bazel_file and src_suffix == "":
            continue
        elif gen_core_file and src_suffix == ".core":
            tpl = Template(filename=str(files(templates) / "fusesoc" / ftpl))
        elif gen_bazel_file and src_suffix == "":
            tpl = Template(filename=str(files(templates) / "bazel" / ftpl))
            if 'tests' in ftpl:
                if seq_lib_location != "tests":
                    ftpl = ftpl.replace('tests', seq_lib_location)
                file_name = "/".join(ftpl.split('-')[:-1] + ["BUILD"])
            else:
                file_name = 'BUILD'
            bzl_relative_dir = str(Path(root_dir).relative_to(Path(bazel_root)))  # noqa: E501
        else:
            tpl = Template(filename=str(files(templates) / "bench" / ftpl))

        file_path = os.path.join(path_dir, file_name)

        Path(file_path).parent.mkdir(parents=True, exist_ok=True)

        # create rendered file
        with open(file_path, 'w') as fout:
            try:
                fout.write(
                    tpl.render(name=name,
                               has_ral=has_ral,
                               env_agents=env_agents,
                               vendor=vendor,
                               license_header=license_header,
                               include_dirs=src_dirs,
                               sv_files=sv_files,
                               bzl_relative_dir=bzl_relative_dir,
                               default_timescale=default_timescale,
                               default_header_ext=default_header_ext,
                               is_cip=is_cip,
                               has_alerts=has_alerts,
                               has_interrupts=has_interrupts,
                               num_edn=num_edn,
                               seq_lib_location=seq_lib_location))
            except Exception as e:
                log.error(e.text_error_template().render())
