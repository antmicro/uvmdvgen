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
  `include "${name}_vseq_list.svh"
  `include "${name}_base_test.svh"

endpackage
