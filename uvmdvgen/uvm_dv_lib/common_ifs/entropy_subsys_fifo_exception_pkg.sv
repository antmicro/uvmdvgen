// Copyright (c) 2019-2024 lowRISC <lowrisc.org>
// Copyright (c) 2024-2025 Antmicro <www.antmicro.com>
//
// SPDX-License-Identifier: Apache-2.0

//
// Datatypes for describing FIFO exceptions in the Entropy Subsystem
//

package entropy_subsys_fifo_exception_pkg;

  typedef enum int {
    FIFO_READ_ERR  = 0,
    FIFO_WRITE_ERR,
    FIFO_STATE_ERR,
    N_FIFO_ERR_TYPES
  } fifo_exception_e;

endpackage
