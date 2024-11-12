% if license_header:
% for line in license_header:
// ${line.strip()}
% endfor

%endif
% if default_timescale:
`timescale ${default_timescale}

%endif
class ${name}_common_vseq extends ${name}_base_vseq;
  `uvm_object_utils(${name}_common_vseq)

  constraint num_trans_c {
    num_trans inside {[1:2]};
  }
  `uvm_object_new

  virtual task body();
% if is_cip:
    run_common_vseq_wrapper(num_trans);
% elif has_ral:
    run_csr_vseq_wrapper(num_trans);
% endif
  endtask : body

endclass
