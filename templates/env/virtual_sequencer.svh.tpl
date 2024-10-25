`timescale 1ns/1ps

class ${name}_virtual_sequencer extends dv_base_virtual_sequencer #(
    .CFG_T(${name}_env_cfg),
    .COV_T(${name}_env_cov)
  );
  `uvm_component_utils(${name}_virtual_sequencer)

% for agent in env_agents:
  ${agent}_sequencer ${agent}_sequencer_h;
% endfor

  `uvm_component_new

endclass
