# Copyright (c) 2019-2024 lowRISC <lowrisc.org>
# Copyright (c) 2024-2025 Antmicro <www.antmicro.com>
#
# SPDX-License-Identifier: Apache-2.0

"""Generate SystemVerilog UVM agent extended freom our DV lib
"""

import os
import logging as log

from mako.template import Template
from mako import exceptions
from importlib.resources import files
from uvmdvgen import templates
from pathlib import Path


def gen_env(name, has_ral, env_agents, root_dir, vendor, license_header=[],
            envs=[], agents=[], env_type="", module_type="", gen_core_file=True, gen_bazel_file=True, use_svh=True, default_timescale="", is_cip=False, has_alerts=False, has_interrupts=False):
    # yapf: disable
    # flake8: noqa
    # 4-tuple - sub-path, ip name, class name, file ext
    env_srcs = [('dv/env',          name + '_', 'env_cfg',            '.svh'),
                ('dv/env',          name + '_', 'env_cov',            '.svh'),
                ('dv/env',          name + '_', 'env_if',            '.svh'),
                ('dv/env',          name + '_', 'env_if_binder',            '.svh'),
                ('dv/env',          name + '_', 'env_pkg',            '.sv'),
                ('dv/env',          name + '_', 'scoreboard',         '.svh'),
                ('dv/env',          name + '_', 'virtual_sequencer',  '.svh'),
                ('dv/env',          name + '_', 'env',                '.svh'),
                ('dv/env',          name + '_', 'env',                '.core'),
                ('dv/env',          ""        , 'env_build',          ''),
                ('dv/env',          name + '_', 'env',                '.f')]
    # yapf: enable

    default_header_ext = "svh" if use_svh else "sv"

    dirs = []
    sv_files = []
    # skipping the last entry, as it is the dot-f file itself
    for i in env_srcs[:-1]:
        # if the extension is a sv source, compute the full source path
        # relative to the root agent directory, where the dot-f will be generated
        if i[3] in ['.sv', '.svh']:
            sv_files.append(str((Path(i[0]) / (i[1] + i[2] + i[3])).relative_to("dv/env")))
    for i in env_srcs:
        if i[3] in ['.sv', '.svh', '.f', '.core']:
            # append string versions of the directory relative to the agent directory
            dirs.append(str('./' / Path(i[0]).relative_to("dv/env")))
    # Remove duplicates
    dirs = sorted(set(dirs))

    for tup in env_srcs:
        path_dir = root_dir + '/' + tup[0]
        src_prefix = tup[1]
        src = tup[2]
        src_suffix = tup[3]

        ftpl = src + src_suffix + '.tpl'
        header_ext = ".sv" if not use_svh and src_suffix == ".svh" else src_suffix
        file_name = src_prefix + src + header_ext

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
            file_name='BUILD'
        else:
            tpl = Template(filename=str(files(templates) / "env" / ftpl))

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
                               agents=agents,
                               env_name=name,
                               envs=envs,
                               env_type=env_type,
                               module_type=module_type,
                               include_dirs=dirs,
                               sv_files=sv_files,
                               default_timescale=default_timescale,
                               default_header_ext=default_header_ext,
                               is_cip=is_cip,
                               has_alerts=has_alerts,
                               has_interrupts=has_interrupts))
            except:
                log.error(exceptions.text_error_template().render())
