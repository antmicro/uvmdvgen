// Copyright (c) 2019-2024 lowRISC <lowrisc.org>
// Copyright (c) 2024-2025 Antmicro <www.antmicro.com>
//
// SPDX-License-Identifier: Apache-2.0
//
// coverage object for a fixed width mubi
class mubi_cov #(parameter int Width = 4,
                 parameter int unsigned ValueTrue = prim_mubi_pkg::MuBi4True,
                 parameter int unsigned ValueFalse = prim_mubi_pkg::MuBi4False) extends uvm_object;
  `uvm_object_param_utils(mubi_cov #(Width, ValueTrue, ValueFalse))

  // Collect true, false and at least N other values (N = Width)
  covergroup mubi_cg(string name) with function sample(bit [Width-1:0] value);
    option.per_instance = 1;
    option.name         = name;

    cp_value: coverpoint value {
      bins true = {ValueTrue};
      bins false = {ValueFalse};
      bins others[Width] = {[0:{Width{1'b1}}]} with (!(item inside {ValueTrue, ValueFalse}));
    }
  endgroup : mubi_cg

  // use reg_field name as this name
  function new(string name = "");
    mubi_cg = new($sformatf("mubi%0d_cov_of_%s", Width, name));
  endfunction : new

  virtual function void sample(bit [Width-1:0] value);
    mubi_cg.sample(value);
  endfunction : sample
endclass : mubi_cov

// TODO(#24142): This is a bit silly: it's just mubi_cov above, specialised to Width=32. But that
// doesn't work properly with VCS (tried with version 2023.03) because it ends up creating an
// enormous number of bins. Setting an explicit width here works around the problem. Fix this up
// properly if we change tool version.
class mubi32_cov extends uvm_object;
  `uvm_object_param_utils(mubi32_cov)

  // Collect true, false and at least N other values (N = 32)
  covergroup mubi_cg(string name) with function sample(bit [32-1:0] value);
    option.per_instance = 1;
    option.name         = name;

    cp_value: coverpoint value {
      bins true = {prim_mubi_pkg::MuBi32True};
      bins false = {prim_mubi_pkg::MuBi32False};
      bins others[32] = {[0:{32{1'b1}}]} with (!(item inside {prim_mubi_pkg::MuBi32True,
                                                              prim_mubi_pkg::MuBi32False}));
    }
  endgroup : mubi_cg

  // use reg_field name as this name
  function new(string name = "");
    mubi_cg = new($sformatf("mubi%0d_cov_of_%s", 32, name));
  endfunction : new

  virtual function void sample(bit [32-1:0] value);
    mubi_cg.sample(value);
  endfunction : sample
endclass

typedef mubi_cov #(.Width(4),
                   .ValueTrue(prim_mubi_pkg::MuBi4True),
                   .ValueFalse(prim_mubi_pkg::MuBi4False)) mubi4_cov;
typedef mubi_cov #(.Width(8),
                   .ValueTrue(prim_mubi_pkg::MuBi8True),
                   .ValueFalse(prim_mubi_pkg::MuBi8False)) mubi8_cov;
typedef mubi_cov #(.Width(12),
                   .ValueTrue(prim_mubi_pkg::MuBi12True),
                   .ValueFalse(prim_mubi_pkg::MuBi12False)) mubi12_cov;
typedef mubi_cov #(.Width(16),
                   .ValueTrue(prim_mubi_pkg::MuBi16True),
                   .ValueFalse(prim_mubi_pkg::MuBi16False)) mubi16_cov;
typedef mubi_cov #(.Width(20),
                   .ValueTrue(prim_mubi_pkg::MuBi20True),
                   .ValueFalse(prim_mubi_pkg::MuBi20False)) mubi20_cov;
typedef mubi_cov #(.Width(24),
                   .ValueTrue(prim_mubi_pkg::MuBi24True),
                   .ValueFalse(prim_mubi_pkg::MuBi24False)) mubi24_cov;
typedef mubi_cov #(.Width(28),
                   .ValueTrue(prim_mubi_pkg::MuBi28True),
                   .ValueFalse(prim_mubi_pkg::MuBi28False)) mubi28_cov;

// a mubi coverage object, which allows to dynamically select the width of mubi
class dv_base_mubi_cov extends uvm_object;
  int mubi_width = 0;

  // declare all mubi types, but only one will be created
  mubi4_cov m_mubi4_cov;
  mubi8_cov m_mubi8_cov;
  mubi12_cov m_mubi12_cov;
  mubi16_cov m_mubi16_cov;
  mubi20_cov m_mubi20_cov;
  mubi24_cov m_mubi24_cov;
  mubi28_cov m_mubi28_cov;
  mubi32_cov m_mubi32_cov;

  `uvm_object_utils(dv_base_mubi_cov)
  `uvm_object_new

  // use reg_field name as this name
  function void create_cov(int mubi_width);
    string cov_name = $sformatf("mubi%0d_cov_of_%s", mubi_width, `gfn);

    // create_cov can be invoked only once
    `DV_CHECK_EQ(this.mubi_width, 0)
    this.mubi_width = mubi_width;

    case (mubi_width)
      4:  m_mubi4_cov  = mubi4_cov::type_id::create(cov_name);
      8:  m_mubi8_cov  = mubi8_cov::type_id::create(cov_name);
      12: m_mubi12_cov = mubi12_cov::type_id::create(cov_name);
      16: m_mubi16_cov = mubi16_cov::type_id::create(cov_name);
      20: m_mubi20_cov = mubi20_cov::type_id::create(cov_name);
      24: m_mubi24_cov = mubi24_cov::type_id::create(cov_name);
      28: m_mubi28_cov = mubi28_cov::type_id::create(cov_name);
      32: m_mubi32_cov = mubi32_cov::type_id::create(cov_name);
      default: `uvm_fatal(`gfn, $sformatf("Unsupported mubi width (%0d) is used", mubi_width))
    endcase
  endfunction : create_cov

  virtual function void sample(int value);
    case (mubi_width)
      4:  m_mubi4_cov.sample(value);
      8:  m_mubi8_cov.sample(value);
      12: m_mubi12_cov.sample(value);
      16: m_mubi16_cov.sample(value);
      20: m_mubi20_cov.sample(value);
      24: m_mubi24_cov.sample(value);
      28: m_mubi28_cov.sample(value);
      32: m_mubi32_cov.sample(value);
      default: `uvm_fatal(`gfn, $sformatf("Unsupported mubi width (%0d) is used", mubi_width))
    endcase
  endfunction : sample
endclass : dv_base_mubi_cov
