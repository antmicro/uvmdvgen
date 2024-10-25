`timescale 1ns/1ps

module ${name}_bind;
% if has_ral:

  bind ${name} ${name}_csr_assert_fpv ${name}_csr_assert (
    .clk_i,
    .rst_ni,
    .h2d    (tl_i),
    .d2h    (tl_o)
  );
% endif

endmodule
