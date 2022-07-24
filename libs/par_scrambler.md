# Entity: par_scrambler 

- **File**: par_scrambler.vhd
## Diagram

![Diagram](par_scrambler.svg "Diagram")
## Generics

| Generic name     | Type    | Value | Description |
| ---------------- | ------- | ----- | ----------- |
| Data_Width       | integer | 8     |             |
| Polynomial_Order | integer | 8     |             |
## Ports

| Port name  | Direction | Type                                         | Description |
| ---------- | --------- | -------------------------------------------- | ----------- |
| rst        | in        | std_logic                                    |             |
| clk        | in        | std_logic                                    |             |
| scram_rst  | in        | std_logic                                    |             |
| Polynomial | in        | std_logic_vector (Polynomial_Order downto 0) |             |
| data_in    | in        | std_logic_vector (Data_Width-1 downto 0)     |             |
| scram_en   | in        | std_logic                                    |             |
| data_out   | out       | std_logic_vector (Data_Width-1 downto 0)     |             |
| out_valid  | out       | std_logic                                    |             |
## Processes
- scram_p: ( clk,rst )
