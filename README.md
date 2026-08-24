# Cyclic-redundancy-checker-Verilog

This repository provides CRC checker modules in Verilog for Xilinx (including ZedBoard) flows:

- `rtl/crc_serial_checker.v` – serial 1-bit-per-cycle CRC checker
- `rtl/crc_parallel_checker.v` – parallel N-bit-per-cycle CRC checker (default byte-wide)

Both modules are parameterized:

- `WIDTH` – CRC width (default `8`)
- `POLY` – generator polynomial without the implicit top `x^WIDTH` term (default `8'h07`)
- `DATA_WIDTH` – input width for parallel checker (default `8`)

## Interfaces

### Serial checker (`crc_serial_checker`)
- `bit_valid` + `bit_in`: accepted on clock edge when `bit_valid=1`
- `clear`: synchronously clears CRC state to zero
- `crc`: current CRC remainder
- `crc_ok`: high when `crc` remainder is zero

### Parallel checker (`crc_parallel_checker`)
- `data_valid` + `data_in`: accepted on clock edge when `data_valid=1`
- `clear`: synchronously clears CRC state to zero
- `crc`: current CRC remainder
- `crc_ok`: high when `crc` remainder is zero

## Testbenches

- `tb/tb_crc_serial_checker.v`
- `tb/tb_crc_parallel_checker.v`

The testbenches validate CRC-8 (`POLY=8'h07`) with the standard `"123456789"` payload (`CRC=8'hF4`) and verify zero-remainder checking when the CRC byte is appended.
