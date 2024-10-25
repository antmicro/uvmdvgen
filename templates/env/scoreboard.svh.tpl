`timescale 1ns/1ps

class ${name}_scoreboard extends dv_base_scoreboard #(
    .CFG_T(${name}_env_cfg),
% if has_ral:
    .RAL_T(${name}_reg_block),
% endif
    .COV_T(${name}_env_cov)
  );
  `uvm_component_utils(${name}_scoreboard)

  // local variables

  // TLM agent fifos
% for agent in env_agents:
  uvm_tlm_analysis_fifo #(${agent}_item) ${agent}_fifo;
% endfor

  // local queues to hold incoming packets pending comparison
% for agent in env_agents:
  ${agent}_item ${agent}_q[$];
% endfor

  `uvm_component_new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
% for agent in env_agents:
    ${agent}_fifo = new("${agent}_fifo", this);
% endfor
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
% for agent in env_agents:
      process_${agent}_fifo();
% endfor
    join_none
  endtask
% for agent in env_agents:

  virtual task process_${agent}_fifo();
    ${agent}_item item;
    forever begin
      ${agent}_fifo.get(item);
      `uvm_info(`gfn, $sformatf("received ${agent} item:\n%0s", item.sprint()), UVM_HIGH)
    end
  endtask
% endfor

  virtual function void reset(string kind = "HARD");
    super.reset(kind);
    // reset local fifos queues and variables
  endfunction

  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    // post test checks - ensure that all local fifos and queues are empty
  endfunction

endclass
