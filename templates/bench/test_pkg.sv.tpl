// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns/1ps

package ${name}_test_pkg;
  // dep packages
  import uvm_pkg::*;
  import dv_lib_pkg::*;
  import ${name}_env_pkg::*;

  // macro includes
  `include "uvm_macros.svh"
  `include "dv_macros.svh"

  // local types

  // functions

  // package sources
  `include "${name}_vseq_list.sv"
  `include "${name}_base_test.sv"

endpackage
