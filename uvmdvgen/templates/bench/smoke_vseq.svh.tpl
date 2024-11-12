% if license_header:
% for line in license_header:
// ${line.strip()}
% endfor

%endif
% if default_timescale:
`timescale ${default_timescale}

%endif
// smoke test vseq
class ${name}_smoke_vseq extends ${name}_base_vseq;
  `uvm_object_utils(${name}_smoke_vseq)

  `uvm_object_new

  task body();
    `uvm_info(`gfn, "Smoke test", UVM_MEDIUM)
    `uvm_error(`gfn, "FIXME")
  endtask : body

endclass : ${name}_smoke_vseq
