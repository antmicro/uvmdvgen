// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns/1ps

class ${name}_common_vseq extends ${name}_base_vseq;
  `uvm_object_utils(${name}_common_vseq)

  constraint num_trans_c {
    num_trans inside {[1:2]};
  }
  `uvm_object_new

  virtual task body();
% if has_ral:
    run_csr_vseq_wrapper(num_trans);
% endif
  endtask : body

endclass
