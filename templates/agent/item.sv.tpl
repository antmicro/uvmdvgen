// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns/1ps

class ${name}_item extends uvm_sequence_item;

  // random variables

  `uvm_object_utils_begin(${name}_item)
  `uvm_object_utils_end

  `uvm_object_new

endclass
