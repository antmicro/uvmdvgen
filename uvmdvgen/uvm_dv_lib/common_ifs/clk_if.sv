// Copyright (c) 2019-2024 lowRISC <lowrisc.org>
// Copyright (c) 2024-2025 Antmicro <www.antmicro.com>
//
// SPDX-License-Identifier: Apache-2.0

//----------------------------- DESCRIPTION ------------------------------------
//
// Generic clock interface for clock events in various utilities
//
//------------------------------------------------------------------------------

interface clk_if(input logic clk);

  clocking cb @(posedge clk);
  endclocking

  clocking cbn @(negedge clk);
  endclocking

  // Wait for 'n' clocks based of postive clock edge
  task automatic wait_clks(int num_clks);
    repeat (num_clks) @cb;
  endtask

  // Wait for 'n' clocks based of negative clock edge
  task automatic wait_n_clks(int num_clks);
    repeat (num_clks) @cbn;
  endtask

endinterface
