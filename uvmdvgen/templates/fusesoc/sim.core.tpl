CAPI=2:
% for line in license_header:
# ${line.strip()}
% endfor
name: "${vendor}:dv:${name}_sim:0.1"
description: "${name.upper()} DV sim target"
filesets:
  files_rtl:
    depend:
      - ${vendor}:ip:${name}

  files_dv:
    depend:
      - ${vendor}:dv:${name}_test
      - ${vendor}:dv:${name}_sva
    files:
      - tb.sv
    file_type: systemVerilogSource

targets:
  sim: &sim_target
    toplevel: tb
    filesets:
      - files_rtl
      - files_dv
    default_tool: vcs

  # TODO: add a lint check cfg in `hw/top_earlgrey/lint/top_earlgrey_dv_lint_cfgs.hjson`
  lint:
    <<: *sim_target
