% if license_header:
% for line in license_header:
// ${line.strip()}
% endfor

% endif
% if default_timescale:
`timescale ${default_timescale}

%endif
class ${name}_base_seq extends dv_base_seq #(
    .REQ         (${name}_item),
    .CFG_T       (${name}_agent_cfg),
    .SEQUENCER_T (${name}_sequencer)
  );
  `uvm_object_utils(${name}_base_seq)

  `uvm_object_new

  virtual task body();
    `uvm_fatal(`gtn, "Need to override this when you extend from this class!")
  endtask

endclass
