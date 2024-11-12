% if license_header:
% for line in license_header:
// ${line.strip()}
% endfor

% endif
% if default_timescale:
`timescale ${default_timescale}

%endif
class ${name}_item extends uvm_sequence_item;

  // random variables

  `uvm_object_utils_begin(${name}_item)
  `uvm_object_utils_end

  `uvm_object_new

endclass
