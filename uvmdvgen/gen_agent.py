# Copyright (c) 2019-2024 lowRISC <lowrisc.org>
# Copyright (c) 2024-2025 Antmicro <www.antmicro.com>
#
# SPDX-License-Identifier: Apache-2.0

"""Generate SystemVerilog UVM agent extended freom our DV lib
"""

import os

from mako import exceptions
from mako.template import Template
from importlib.resources import files
import logging as log
from pathlib import Path
from uvmdvgen import templates

def filter_sv_files(sv_files, driver_toggle, name):
    if driver_toggle:
        return list([i for i in sv_files if not name+"_driver" not in str(i)])
    return list([i for i in sv_files if name+"_host_driver" not in str(i) and name+"_device_driver" not in str(i)])



def gen_agent(name, has_separate_host_device_driver, root_dir, vendor,
              license_header=[], module_type="", interface_name="", wires=[], gen_core_file=True, gen_bazel_file=True, use_svh=True, default_timescale=""):
    # set sub name
    agent_dir = root_dir + "/" + name + "_agent"

    default_header_ext = "svh" if use_svh else "sv"

    # yapf: disable
    # flake8: noqa
    # 4-tuple - path, ip name, class name, file ext
    agent_srcs = [(agent_dir,               name + '_', 'if',            '.sv'),
                  (agent_dir,               name + '_', 'item',          '.svh'),
                  (agent_dir,               name + '_', 'agent_cfg',     '.svh'),
                  (agent_dir,               name + '_', 'agent_cov',     '.svh'),
                  (agent_dir,               name + '_',
                   'agent_interface_binder',     '.sv'),
                  (agent_dir,               name + '_', 'monitor',       '.svh'),
                  (agent_dir,               name + '_', 'driver',        '.svh'),
                  (agent_dir,               name + '_', 'host_driver',   '.svh'),
                  (agent_dir,               name + '_', 'device_driver', '.svh'),
                  (agent_dir,               name + '_', 'agent_pkg',     '.sv'),
                  (agent_dir,               name + '_', 'agent',         '.svh'),
                  (agent_dir,               name + '_', 'agent',         '.core'),
                  (agent_dir,               "",         'README',        '.md'),
                  (agent_dir + "/seq_lib",  name + '_', 'seq_list',      '.svh'),
                  (agent_dir + "/seq_lib",  name + '_', 'base_seq',      '.svh'),
                  (agent_dir,               ""        , 'agent_build',       ''),
                  (agent_dir,               name + '_', 'agent',      '.f')]
    # yapf: enable

    dirs = []
    sv_files = []
    # skipping the last entry, as it is the dot-f file itself
    for i in agent_srcs[:-1]:
        # if the extension is a sv source or header, compute the full source path
        # relative to the root agent directory, where the dot-f will be generated
        if i[3] in ['.sv', '.svh']:
            sv_files.append(str((Path(i[0]) / (i[1] + i[2] + i[3])).relative_to(agent_dir)))
    for i in agent_srcs:
        if i[3] in ['.sv', '.svh', '.f', '.core']:
            # append string versions of the directory relative to the agent directory
            dirs.append(str('./' / Path(i[0]).relative_to(agent_dir)))
    # Remove duplicates
    dirs = sorted(set(dirs))

    for tup in agent_srcs:
        path_dir = tup[0]
        src_prefix = tup[1]
        src = tup[2]
        src_suffix = tup[3]

        if has_separate_host_device_driver and src == "driver":
            sv_files = filter_sv_files(sv_files, has_separate_host_device_driver, name)
            continue
        elif not has_separate_host_device_driver and (src == "host_driver" or src == "device_driver"):
            sv_files = filter_sv_files(sv_files, has_separate_host_device_driver, name)
            continue

        ftpl = src + src_suffix + '.tpl'
        header_ext = ".sv" if not use_svh and src_suffix == ".svh" else src_suffix
        fname = src_prefix + src + header_ext

        # read template
        tpl = None

        if not gen_core_file and src_suffix == ".core":
            continue
        elif not gen_bazel_file and src_suffix == "":
            continue
        elif gen_core_file and src_suffix == ".core":
            tpl = Template(filename=str(files(templates) / "fusesoc" / ftpl))
        elif gen_bazel_file and src_suffix == "":
            tpl = Template(filename=str(files(templates) / "bazel" / ftpl))
            fname = 'BUILD'
        else:
            tpl = Template(filename=str(files(templates) / "agent" / ftpl))

        if not os.path.exists(path_dir):
            os.system("mkdir -p " + path_dir)
        with open(path_dir + "/" + fname, 'w') as fout:
            try:
                fout.write(
                    tpl.render(name=name,
                               has_separate_host_device_driver=has_separate_host_device_driver,
                               vendor=vendor,
                               license_header=license_header,
                               module_type=module_type,
                               interface_name=interface_name,
                               agent_name=name,
                               wires=wires,
                               include_dirs = dirs,
                               sv_files=sv_files,
                               default_timescale=default_timescale,
                               default_header_ext=default_header_ext))
            except:
                log.error(exceptions.text_error_template().render())
