# uvmdvgen

Copyright (c) 2019-2025 [lowRISC](https://lowrisc.org/)

Copyright (c) 2024-2025 [Antmicro](https://www.antmicro.com)

A tool for generating the boilerplate code for a UVM agent, as well as the complete UVM testbench for a given DUT.

It is based on [OpenTitan's uvmdvgen tool](https://github.com/lowRISC/opentitan/tree/master/util/uvmdvgen), extracted as a standalone module.

## Installation

To install the tool, run:

```bash
pip3 install git+https://github.com/antmicro/uvmdvgen.git
```

After this, the tool is available as `uvmdvgen`, e.g.:

```bash
uvmdvgen --help
```

`--help` flag will provide all available flags for the tool.

## Examples

Assume you want to create agents for i2c, with `example` vendor name and license header with following example content:

```
Copyright (c) YYYY example <www.example.com>

SPDX-License-Identifier: Apache 2.0
```

To do so, first create a `license-header.txt` file with the above content, and then run:

```bash
uvmdvgen i2c -a -s -ao hw/dv/sv --license-header ./license-header.txt --fusesoc --vendor example
```

Then, to create an `i2c_host` DV testbench instantiating `i2c_agent`, run:

```bash
uvmdvgen i2c_host -e -c -hi -hr -ea i2c -eo hw/ip/i2c_host/dv -b -bo hw/ip/i2c_host/dv --license-header ./license-header.txt --fusesoc --vendor example --seq-lib-location env
```

Other possible calls may look as follows:

```bash
# Create full DV testbench for foo
uvmdvgen foo -e -c -hi -ha -hr -ea foo -eo hw/ip/i2c_host/dv -b -bo hw/ip/i2c_host/dv --license-header ./license-header.txt --fusesoc --vendor example --seq-lib-location env

# Create the complete DV testbench for dma extended from DV lib
uvmdvgen dma -e -eo hw/ip/dma/dv -b -bo hw/ip/dma/dv --license-header ./license-header.txt --fusesoc --vendor example --seq-lib-location env
```

## Initializing a workspace with static tools and libraries

`uvmdvgen` provides a set of libraries for generated testbenches.
They can be copied to a target directory with `--init-workspace` flag, e.g.:

```bash
uvmdvgen --init-workspace example-project
```
