// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns/1ps

// smoke test vseq
class ${name}_smoke_vseq extends ${name}_base_vseq;
  `uvm_object_utils(${name}_smoke_vseq)

  `uvm_object_new

  task body();
    `uvm_info(`gfn, "Smoke test", UVM_MEDIUM)
    `uvm_warning(`gfn, "FIXME")
  endtask : body

endclass : ${name}_smoke_vseq
