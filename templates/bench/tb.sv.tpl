// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
`timescale 1ns/1ps

module tb;
  // dep packages
  import uvm_pkg::*;
  import dv_utils_pkg::*;
  import ${name}_env_pkg::*;
  import ${name}_test_pkg::*;

  // macro includes
  `include "uvm_macros.svh"
  `include "dv_macros.svh"

  wire clk, rst_n;

  // interfaces
  clk_rst_if clk_rst_if(.clk(clk), .rst_n(rst_n));
% for agent in env_agents:
  ${agent}_if ${agent}_if();
% endfor


  // dut
  ${name} dut (
    .clk_i                (clk      )
    // TODO: add remaining IOs and hook them
  );

  initial begin
    // drive clk and rst_n from clk_if
    clk_rst_if.set_sole_clock();
    clk_rst_if.set_active();
    uvm_config_db#(virtual clk_rst_if)::set(null, "*.env", "clk_rst_vif", clk_rst_if);
% for agent in env_agents:
    uvm_config_db#(virtual ${agent}_if)::set(null, "*.env.m_${agent}_agent*", "vif", ${agent}_if);
% endfor
    $timeformat(-12, 0, " ps", 12);
    run_test();
  end

endmodule
