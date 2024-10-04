# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
"""Generate SystemVerilog UVM agent extended freom our DV lib
"""

import os
import logging as log

from mako.template import Template
import importlib_resources

def gen_env(name, is_cip, has_ral, has_interrupts, has_alerts, num_edn,
            env_agents, root_dir, vendor, license_header="", gen_core_file=True):
    # yapf: disable
    # flake8: noqa
    # 4-tuple - sub-path, ip name, class name, file ext
    env_srcs = [('dv/env',          name + '_', 'env_cfg',            '.sv'),
                ('dv/env',          name + '_', 'env_cov',            '.sv'),
                ('dv/env',          name + '_', 'env_pkg',            '.sv'),
                ('dv/env',          name + '_', 'scoreboard',         '.sv'),
                ('dv/env',          name + '_', 'virtual_sequencer',  '.sv'),
                ('dv/env',          name + '_', 'env',                '.sv'),
                ('dv/env',          name + '_', 'env',                '.core')]
    # yapf: enable

    for tup in env_srcs:
        path_dir = root_dir + '/' + tup[0]
        src_prefix = tup[1]
        src = tup[2]
        src_suffix = tup[3]

        ftpl = src + src_suffix + '.tpl'
        file_name = src_prefix + src + src_suffix

        if not os.path.exists(path_dir):
            os.system("mkdir -p " + path_dir)
        if file_name == "":
            continue

        file_path = os.path.join(path_dir, file_name)

        # read template
        if not gen_core_file and src_suffix == ".core":
            continue
        elif gen_core_file and src_suffix == ".core":
            tpl = Template(filename=str(importlib_resources.files('scripts').parent/"templates"/"fusesoc"/ftpl))
        else:
            tpl = Template(filename=str(importlib_resources.files('scripts').parent/"templates"/"env"/ftpl))

        # create rendered file
        with open(file_path, 'w') as fout:
            try:
                fout.write(
                    tpl.render(name=name,
                               is_cip=is_cip,
                               has_ral=has_ral,
                               has_interrupts=has_interrupts,
                               has_alerts=has_alerts,
                               num_edn=num_edn,
                               env_agents=env_agents,
                               vendor=vendor,
                               license_header=license_header))
            except Exception as e:
                log.error(e.text_error_template().render())
