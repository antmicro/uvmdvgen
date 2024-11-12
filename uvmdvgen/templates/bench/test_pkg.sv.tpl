% if license_header:
% for line in license_header:
// ${line.strip()}
% endfor

%endif
% if default_timescale:
`timescale ${default_timescale}

%endif
package ${name}_test_pkg;
  // dep packages
  import uvm_pkg::*;
% if is_cip:
  import cip_base_pkg::*;
% else:
  import dv_lib_pkg::*;
% endif
  import ${name}_env_pkg::*;

  // macro includes
  `include "uvm_macros.svh"
  `include "dv_macros.svh"

  // local types

  // functions

  // package sources
  `include "${name}_vseq_list.${default_header_ext}"
  `include "${name}_base_test.${default_header_ext}"

endpackage
