% if license_header:
% for line in license_header:
// ${line.strip()}
% endfor

% endif
% if default_timescale:
`timescale ${default_timescale}

%endif
`include "${name}_base_vseq.${default_header_ext}"
`include "${name}_smoke_vseq.${default_header_ext}"
`include "${name}_common_vseq.${default_header_ext}"
