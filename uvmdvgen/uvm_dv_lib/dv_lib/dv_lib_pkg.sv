// Copyright (c) 2019-2024 lowRISC <lowrisc.org>
// Copyright (c) 2024-2025 Antmicro <www.antmicro.com>
//
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns/1ps

package dv_lib_pkg;
  // dep packages
  import uvm_pkg::*;
  import bus_params_pkg::*;
  import dv_utils_pkg::*;
  import csr_utils_pkg::*;
  import dv_base_reg_pkg::*;

  // macro includes
  `include "uvm_macros.svh"
  `include "dv_macros.svh"

  // package variables
  string msg_id = "dv_lib_pkg";

  // package sources
  // base agent
  `include "dv_base_agent_cfg.svh"
  `include "dv_base_agent_cov.svh"
  `include "dv_base_monitor.svh"
  `include "dv_base_sequencer.svh"
  `include "dv_base_driver.svh"
  `include "dv_base_agent.svh"

  // base seq
  `include "dv_base_seq.svh"

  // base env
  `include "dv_base_env_cfg.svh"
  `include "dv_base_env_cov.svh"
  `include "dv_base_virtual_sequencer.svh"
  `include "dv_base_scoreboard.svh"
  `include "dv_base_env.svh"

  // base test vseq
  `include "dv_base_vseq.svh"

  // base test
  `include "dv_base_test.svh"

endpackage
