% if license_header:
% for line in license_header:
// ${line.strip()}
% endfor

% endif
% if default_timescale:
`timescale ${default_timescale}

%endif
class ${name}_device_driver extends ${name}_driver;
  `uvm_component_utils(${name}_device_driver)

  // the base class provides the following handles for use:
  // ${name}_agent_cfg: cfg

  `uvm_component_new

  virtual task run_phase(uvm_phase phase);
    // base class forks off reset_signals() and get_and_drive() tasks
    super.run_phase(phase);
  endtask

  // reset signals
  virtual task reset_signals();
  endtask

  // drive trans received from sequencer
  virtual task get_and_drive();
  endtask

endclass
