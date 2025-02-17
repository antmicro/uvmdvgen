% if license_header:
% for line in license_header:
// ${line.strip()}
% endfor

% endif
% if default_timescale:
`timescale ${default_timescale}

%endif
// macro includes
`include "uvm_macros.svh"
`include "dv_macros.svh"

class ${name}_agent_cfg extends dv_base_agent_cfg;

  // interface handle used by driver, monitor & the sequencer, via cfg handle
  virtual ${name}_if vif;

  `uvm_object_utils_begin(${name}_agent_cfg)
  `uvm_object_utils_end

  `uvm_object_new

endclass
