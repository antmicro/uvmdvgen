% if license_header:
% for line in license_header:
// ${line.strip()}
% endfor

% endif
% if default_timescale:
`timescale ${default_timescale}

%endif
package ${name}_env_pkg;
  // dep packages
  import uvm_pkg::*;
  import top_pkg::*;
  import dv_utils_pkg::*;
% for agent in env_agents:
  import ${agent}_agent_pkg::*;
% endfor
  import dv_lib_pkg::*;
% if is_cip:
  import tl_agent_pkg::*;
  import cip_base_pkg::*;
% endif
% if not has_ral:
  import dv_base_reg_pkg::*;
% else:
  import csr_utils_pkg::*;
  import ${name}_ral_pkg::*;
% endif

  // macro includes
  `include "uvm_macros.svh"
  `include "dv_macros.svh"

  // parameters
% if has_alerts:
  // TODO: add the names of alerts in order
  parameter string LIST_OF_ALERTS[] = {};
  parameter uint   NUM_ALERTS = ;
% endif

  // types
% if not has_ral:
  typedef dv_base_reg_block ${name}_reg_block;
% endif

  // functions

  // package sources
  `include "${name}_env_cfg.${default_header_ext}"
  `include "${name}_env_cov.${default_header_ext}"
  `include "${name}_virtual_sequencer.${default_header_ext}"
  `include "${name}_scoreboard.${default_header_ext}"
  `include "${name}_env.${default_header_ext}"
  `include "${name}_vseq_list.${default_header_ext}"

endpackage
