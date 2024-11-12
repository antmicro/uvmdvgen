CAPI=2:
% for line in license_header:
# ${line.strip()}
% endfor
name: "lowrisc:dv:${name}_sva:0.1"
description: "${name.upper()} assertion modules and bind file."
filesets:
  files_dv:
    depend:
      - lowrisc:tlul:headers
% if has_ral:
      - lowrisc:fpv:csr_assert_gen
% endif
    files:
      - ${name}_bind.sv
    file_type: systemVerilogSource

  files_formal:
    depend:
      - lowrisc:ip:${name}

% if has_ral:
generate:
  csr_assert_gen:
    generator: csr_assert_gen
    parameters:
      spec: ../../data/${name}.hjson
% endif

targets:
  default: &default_target
    filesets:
      - files_dv
% if has_ral:
    generate:
      - csr_assert_gen
  formal:
    <<: *default_target
    filesets:
      - files_formal
      - files_dv
    toplevel: ${name}
% endif
