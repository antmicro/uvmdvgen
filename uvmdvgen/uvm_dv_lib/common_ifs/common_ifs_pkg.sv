// Copyright (c) 2019-2024 lowRISC <lowrisc.org>
// Copyright (c) 2024-2025 Antmicro <www.antmicro.com>
//
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns/1ps

package common_ifs_pkg;
  // dep packages
  import uvm_pkg::*;

  // Enum representing reset scheme
  typedef enum bit [1:0] {
    RstAssertSyncDeassertSync,
    RstAssertAsyncDeassertSync,
    RstAssertAsyncDeassertASync
  } rst_scheme_e;
endpackage
