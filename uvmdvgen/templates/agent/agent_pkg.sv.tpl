% if license_header:
% for line in license_header:
// ${line.strip()}
% endfor

% endif
% if default_timescale:
`timescale ${default_timescale}

%endif
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
  `include "${name}_item.${default_header_ext}"
  `include "${name}_agent_cfg.${default_header_ext}"
  `include "${name}_agent_cov.${default_header_ext}"
% if has_separate_host_device_driver:
  `include "${name}_host_driver.${default_header_ext}"
  `include "${name}_device_driver.${default_header_ext}"
% else:
  `include "${name}_driver.${default_header_ext}"
% endif
  `include "${name}_monitor.${default_header_ext}"
  `include "${name}_agent.${default_header_ext}"
  `include "${name}_seq_list.${default_header_ext}"

endpackage: ${name}_agent_pkg
