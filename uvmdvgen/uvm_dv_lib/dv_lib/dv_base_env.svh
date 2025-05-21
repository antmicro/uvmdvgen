// Copyright (c) 2019-2024 lowRISC <lowrisc.org>
// Copyright (c) 2024-2025 Antmicro <www.antmicro.com>
//
// SPDX-License-Identifier: Apache-2.0

class dv_base_env #(type CFG_T               = dv_base_env_cfg,
                    type VIRTUAL_SEQUENCER_T = dv_base_virtual_sequencer,
                    type SCOREBOARD_T        = dv_base_scoreboard,
                    type COV_T               = dv_base_env_cov) extends uvm_env;
  `uvm_component_param_utils(dv_base_env #(CFG_T, VIRTUAL_SEQUENCER_T, SCOREBOARD_T, COV_T))

  CFG_T                      cfg;
  VIRTUAL_SEQUENCER_T        virtual_sequencer;
  SCOREBOARD_T               scoreboard;
  COV_T                      cov;

  `uvm_component_new

  virtual function void build_phase(uvm_phase phase);
    string default_ral_name;
    super.build_phase(phase);
    // get dv_base_env_cfg object from uvm_config_db
    if (!uvm_config_db#(CFG_T)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal(`gfn, "failed to get cfg from uvm_config_db")
    end

    // get clk & reset vifs
    foreach (cfg.clk_rst_names[i]) begin
      string clk_rst_name = cfg.clk_rst_names[i];
      string vif_name = {"clk_rst_vif_", clk_rst_name};
      if (!uvm_config_db#(virtual clk_rst_if)::get(
              this, "", vif_name, cfg.clk_rst_vifs[clk_rst_name]
          )) begin
        `uvm_fatal(`gfn, $sformatf("failed to get clk_rst_if for %0s from uvm_config_db", clk_rst_name))
      end
      if (cfg.clk_rst_vifs[clk_rst_name].drive_clk) begin
        cfg.clk_rst_vifs[clk_rst_name].set_freq_mhz(cfg.clk_freqs_mhz[clk_rst_name]);
      end
    end

    // create components
    if (cfg.en_cov) begin
      cov = COV_T::type_id::create("cov", this);
      cov.cfg = cfg;
    end

    if (cfg.is_active) begin
      virtual_sequencer = VIRTUAL_SEQUENCER_T::type_id::create("virtual_sequencer", this);
      virtual_sequencer.cfg = cfg;
      virtual_sequencer.cov = cov;
    end

    // scb also monitors the reset and call cfg.reset_asserted/reset_deasserted for reset
    scoreboard = SCOREBOARD_T::type_id::create("scoreboard", this);
    scoreboard.cfg = cfg;
    scoreboard.cov = cov;
  endfunction

endclass
