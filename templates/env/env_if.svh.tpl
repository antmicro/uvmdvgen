% for _, sub_env_type, _ in envs:
  `include "${sub_env_type}_if.sv"
% endfor
% for _, _, agent_type in agents:
  `include "${agent_type}_if.sv"
% endfor
interface ${env_name}_if(
% if envs:
    % if agents:
        % for _, sub_env_type, sub_env_name in envs:
  ${sub_env_type}_if ${sub_env_name}_if,
        % endfor
    % else:
        % for _, sub_env_type, sub_env_name in envs[:-1]:
  ${sub_env_type}_if ${sub_env_name}_if,
        % endfor
  ${envs[-1][1]}_if ${envs[-1][2]}_if
    % endif
% endif
% if agents:
    % for _, interface_name, agent_type in agents[:-1]:
  ${agent_type}_if ${interface_name}_${agent_type}_if,
    % endfor
  ${agents[-1][2]}_if ${agents[-1][1]}_${agents[-1][2]}_if,
% endif
);
endinterface

