% for _, sub_env_type, _ in envs:
  `include "${sub_env_type}_if_bind"
% endfor
% for mod_type, interface_name, agent_type in agents:
  `include "${mod_type}_${interface_name}_${agent_type}_if_bind.sv"
% endfor
`ifndef ${env_type.upper()}_IF_BIND
`define ${env_type.upper()}_IF_BIND
module ${env_type}_if_bind ();
bind ${module_type} ${env_type}_if ${env_type}_if(
% if envs:
    % if agents:
        % for module, sub_env_type, sub_env_name in envs:
  .${sub_env_name}_if(${module}.${sub_env_type}_if),
        % endfor
    % else:
        % for module, sub_env_type, sub_env_name in envs[:-1]:
  .${sub_env_name}_if(${module}.${sub_env_type}_if),
        % endfor
  .${envs[-1][2]}_if(${envs[-1][0]}.${envs[-1][1]}_if),
    % endif
% endif
% if agents:
    % for _, interface_name, agent_type in agents[:-1]:
  .${interface_name}_${agent_type}_if(${interface_name}_${agent_type}_if),
    % endfor
  .${agents[-1][1]}_${agents[-1][2]}_if(${agents[-1][1]}_${agents[-1][2]}_if)
% endif
);
endmodule
`endif

