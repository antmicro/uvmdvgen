// Copyright (c) 2019-2024 lowRISC <lowrisc.org>
// Copyright (c) 2024-2025 Antmicro <www.antmicro.com>
//
// SPDX-License-Identifier: Apache-2.0

class dv_base_scoreboard #(type RAL_T = dv_base_reg_block,
                           type CFG_T = dv_base_env_cfg,
                           type COV_T = dv_base_env_cov) extends uvm_component;
  `uvm_component_param_utils(dv_base_scoreboard #(RAL_T, CFG_T, COV_T))

  CFG_T    cfg;
  RAL_T    ral;
  COV_T    cov;

  bit obj_raised      = 1'b0;
  bit under_pre_abort = 1'b0;

  `uvm_component_new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ral = cfg.ral;
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
      monitor_reset();
      sample_resets();
    join_none
  endtask

  virtual task monitor_reset();
    event reset_changed;
    forever begin
      bit any_asserted = 0;
      bit all_deasserted = 1;
      foreach(cfg.clk_rst_vifs[i]) begin
        any_asserted |= !cfg.clk_rst_vifs[i].rst_n;
        all_deasserted &= cfg.clk_rst_vifs[i].rst_n;
      end

      if(any_asserted && !under_reset) begin
        `uvm_info(`gfn, "Detected a reset is asserted", UVM_HIGH)
        cfg.reset_asserted();
      end else if(all_deasserted) begin
        reset();
        cfg.reset_deasserted();
        csr_utils_pkg::clear_outstanding_access();
        `uvm_info(`gfn, "Detected all resets are deasserted", UVM_HIGH);
      end

      // Wait for a change to any rst_n
      // It makes reseting of RAL asynchronous
      foreach(cfg.clk_rst_vifs[i]) begin
        string if_name = i;
        fork
          begin
            @(cfg.clk_rst_vifs[if_name].rst_n);
            ->> reset_changed;
          end
        join_none
      end
      @(reset_changed);
    end
  endtask

  virtual task sample_resets();
    // Do nothing, actual coverage collection is under extended classes.
  endtask

  virtual function void reset(string kind = "HARD");
    // reset the ral model
    foreach (cfg.ral_models[i]) cfg.ral_models[i].reset(kind);
  endfunction

  virtual function void pre_abort();
    super.pre_abort();

    // In UVM, a fatal error normally aborts the test completely and skips the check phase. However,
    // it's sometimes helpful to run that phase on the scoreboard anyway (it might make it easier to
    // debug whatever went wrong), so we do that here.
    //
    // We only run the check phase if we were in the run phase: if something went wrong in the build
    // or connect phase, there's not much point in "checking the run" further. We also have to be
    // careful to avoid an infinite loop, so we set a flag to avoid doing this a second time if we
    // have errors in the check phase.
    if (has_uvm_fatal_occurred() &&
        !under_pre_abort &&
        m_current_phase.is(uvm_run_phase::get())) begin

      under_pre_abort = 1;
      check_phase(m_current_phase);
      under_pre_abort = 0;
    end
  endfunction : pre_abort

endclass
