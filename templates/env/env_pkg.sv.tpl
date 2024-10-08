// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns/1ps

package ${name}_env_pkg;
  // dep packages
  import uvm_pkg::*;
  import top_pkg::*;
  import dv_utils_pkg::*;
% for agent in env_agents:
  import ${agent}_agent_pkg::*;
% endfor
  import dv_lib_pkg::*;
% if not has_ral:
  import dv_base_reg_pkg::*;
% else:
  import csr_utils_pkg::*;
  import ${name}_ral_pkg::*;
% endif

  // macro includes
  `include "uvm_macros.svh"
  `include "dv_macros.svh"

  // parameters

  // types
% if not has_ral:
  typedef dv_base_reg_block ${name}_reg_block;
% endif

  // functions

  // package sources
  `include "${name}_env_cfg.sv"
  `include "${name}_env_cov.sv"
  `include "${name}_virtual_sequencer.sv"
  `include "${name}_scoreboard.sv"
  `include "${name}_env.sv"

endpackage
