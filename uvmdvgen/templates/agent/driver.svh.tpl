% if license_header:
% for line in license_header:
// ${line.strip()}
% endfor

% endif
% if default_timescale:
`timescale ${default_timescale}

%endif
class ${name}_driver extends dv_base_driver #(.ITEM_T(${name}_item),
                                              .CFG_T (${name}_agent_cfg));
  `uvm_component_utils(${name}_driver)

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
    forever begin
      seq_item_port.get_next_item(req);
      $cast(rsp, req.clone());
      rsp.set_id_info(req);
      `uvm_info(`gfn, $sformatf("rcvd item:\n%0s", req.sprint()), UVM_HIGH)
      // TODO: do the driving part
      //
      // send rsp back to seq
      `uvm_info(`gfn, "item sent", UVM_HIGH)
      seq_item_port.item_done(rsp);
    end
  endtask

endclass
