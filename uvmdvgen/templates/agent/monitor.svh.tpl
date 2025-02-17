% if license_header:
% for line in license_header:
// ${line.strip()}
% endfor

% endif
% if default_timescale:
`timescale ${default_timescale}

%endif
class ${name}_monitor extends dv_base_monitor #(
    .ITEM_T (${name}_item),
    .CFG_T  (${name}_agent_cfg),
    .COV_T  (${name}_agent_cov)
  );
  `uvm_component_utils(${name}_monitor)

  // the base class provides the following handles for use:
  // ${name}_agent_cfg: cfg
  // ${name}_agent_cov: cov
  // uvm_analysis_port #(${name}_item): analysis_port

  `uvm_component_new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask

  // collect transactions forever - already forked in dv_base_monitor::run_phase
  virtual protected task collect_trans();
    forever begin
      // TODO: detect event

      // TODO: sample the interface

      // TODO: sample the covergroups

      // TODO: write trans to analysis_port

      // TODO: remove the line below: it is added to prevent zero delay loop in template code
      #1us;
    end
  endtask

endclass
