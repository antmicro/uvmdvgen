`timescale 1ns/1ps

% if has_ral:
class ${name}_env_cfg extends dv_base_env_cfg #(.RAL_T(${name}_reg_block));
% else:
class ${name}_env_cfg extends dv_base_env_cfg;
% endif

  // ext component cfgs
% for agent in env_agents:
  rand ${agent}_agent_cfg m_${agent}_agent_cfg;
% endfor

  `uvm_object_utils_begin(${name}_env_cfg)
% for agent in env_agents:
    `uvm_field_object(m_${agent}_agent_cfg, UVM_DEFAULT)
% endfor
  `uvm_object_utils_end

  `uvm_object_new

  virtual function void initialize(bit [31:0] csr_base_addr = '1);
    super.initialize(csr_base_addr);
% for agent in env_agents:
    // create ${agent} agent config obj
    m_${agent}_agent_cfg = ${agent}_agent_cfg::type_id::create("m_${agent}_agent_cfg");
% endfor
  endfunction

endclass
