% if license_header:
% for line in license_header:
// ${line.strip()}
% endfor

% endif
% if default_timescale:
`timescale ${default_timescale}

%endif
class ${name}_agent_cov extends dv_base_agent_cov #(${name}_agent_cfg);
  `uvm_component_utils(${name}_agent_cov)

  // the base class provides the following handles for use:
  // ${name}_agent_cfg: cfg

  // covergroups

  function new(string name, uvm_component parent);
    super.new(name, parent);
    // instantiate all covergroups here
  endfunction : new

endclass
