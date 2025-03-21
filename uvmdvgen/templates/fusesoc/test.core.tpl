CAPI=2:
% for line in license_header:
# ${line.strip()}
% endfor
name: "${vendor}:dv:${name}_test:0.1"
description: "${name.upper()} DV UVM test"
filesets:
  files_dv:
    depend:
      - ${vendor}:dv:${name}_env
    files:
      - ${name}_test_pkg.sv
      - ${name}_base_test.sv: {is_include_file: true}
    file_type: systemVerilogSource

targets:
  default:
    filesets:
      - files_dv
