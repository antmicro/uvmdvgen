`timescale 1ns/1ps

package ${name}_agent_pkg;
  // dep packages
  import uvm_pkg::*;
  import dv_utils_pkg::*;
  import dv_lib_pkg::*;

  // macro includes
  `include "uvm_macros.svh"
  `include "dv_macros.svh"

  // parameters

  // local types
  // forward declare classes to allow typedefs below
  typedef class ${name}_item;
  typedef class ${name}_agent_cfg;

% if has_separate_host_device_driver:
  // add typedef for ${name}_driver which is dv_base_driver with the right parameter set
  // ${name}_host_driver and ${name}_device_driver will extend from this
  typedef dv_base_driver #(.ITEM_T(${name}_item),
                           .CFG_T (${name}_agent_cfg)) ${name}_driver;

% endif
  // reuse dv_base_sequencer as is with the right parameter set
  typedef dv_base_sequencer #(.ITEM_T(${name}_item),
                              .CFG_T (${name}_agent_cfg)) ${name}_sequencer;

  // functions

  // package sources
  `include "${name}_item.svh"
  `include "${name}_agent_cfg.svh"
  `include "${name}_agent_cov.svh"
% if has_separate_host_device_driver:
  `include "${name}_host_driver.svh"
  `include "${name}_device_driver.svh"
% else:
  `include "${name}_driver.svh"
% endif
  `include "${name}_monitor.svh"
  `include "${name}_agent.svh"
  `include "${name}_seq_list.svh"

endpackage: ${name}_agent_pkg
