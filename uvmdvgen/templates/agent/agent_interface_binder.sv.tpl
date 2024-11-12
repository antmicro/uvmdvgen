% if license_header:
% for line in license_header:
// ${line.strip()}
% endfor

% endif
`ifndef ${module_type.upper()}_${interface_name.upper()}_${agent_name.upper()}_IF_BIND
`define ${module_type.upper()}_${interface_name.upper()}_${agent_name.upper()}_IF_BIND
module ${module_type}_${interface_name}_${agent_name}_if_bind ();
bind ${module_type} ${agent_name}_if ${interface_name}_${agent_name}_if (
% for name, module_name in wires[:-1]:
      .{name}(module_name),
  .{wires[-1][0]}(wires[-1][1])
% endfor
);
endmodule
`endif

