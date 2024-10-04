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
    env_srcs = [('dv/tests/seq_lib',  name + '_', 'base_vseq',          '.sv'),
                ('dv/tests/seq_lib',  name + '_', 'smoke_vseq',         '.sv'),
                ('dv/tests/seq_lib',  name + '_', 'common_vseq',        '.sv'),
                ('dv/tests/seq_lib',  name + '_', 'vseq_list',          '.sv'),
                ('dv',                '',         'tb',                 '.sv'),
                ('dv/sva',            name + '_', 'bind',               '.sv'),
                ('dv/sva',            name + '_', 'sva',                '.core'),
                ('dv/tests',          name + '_', 'base_test',          '.sv'),
                ('dv/tests',          name + '_', 'test_pkg',           '.sv'),
                ('dv/tests',          name + '_', 'test',               '.core'),
                ('dv/cov',            '',         '',                   ''),
                ('dv',                name + '_', 'sim_cfg',            '.hjson'),
                ('data',              name + '_', 'testplan',           '.hjson'),
                ('dv',                name + '_', 'sim',                '.core')]
    # yapf: enable

    if vendor != VENDOR_DEFAULT and env_agents != []:
        env_core_path = root_dir + "/dv/env/" + name + "_env.core"
        print(
            "WARNING: Both, --vendor and --env-agents switches are supplied "
            "on the command line. Please check the VLNV names of the "
            "dependent agents in the generated {} file.".format(env_core_path))

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
            tpl = Template(filename=str(importlib_resources.files('scripts').parent/"templates"/"bench"/ftpl))

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
