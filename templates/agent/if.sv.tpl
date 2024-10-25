`timescale 1ns/1ps

interface ${name}_if (
% if clock:
  input tri ${clock},
% endif
% if reset:
  input tri ${reset},
% endif
% if wires:
% for _, wire in wires[:-1]:
  inout tri ${wire},
% endfor
inout tri ${wires[-1]}
% endif
);

% if clock or reset or wires:
modport passive_port(
% if clock:
  input ${clock},
% endif
% if reset:
  input ${reset},
% endif
% if wires:
% for _, wire in wires[:-1]:
  input ${wire},
input ${wires[-1][1]}
% endfor
% endif
);
%endif

% if clock or reset or wires:
modport init_port(
% if clock:
  input {clock},
% endif
% if reset:
  input {reset},
% endif
% if wires:
% for dir, wire in wires[:-1]:
  input ${dir} ${wire},
input ${wires[-1][0]} ${wires[-1][1]}
% endfor
% endif
);
%endif

% if clock or reset or wires:
modport resp_port(
% if clock:
  input {clock},
% endif
% if reset:
  input {reset},
% endif
% if wires:
<%
    def opposit_dir(dir):
        if dir == "input":
            return "output"
        elif dir == "output":
            return "input"
        else:
            return dir
    opposite = [(opposit_dir(dir), wire) for dir, wire in wires]
%>
% for dir, wire in opposite[:-1]:
  ${dir} ${wire},
% endfor
${opposite[-1][0]} ${opposite[-1][1]}
% endif
);
%endif

endinterface
