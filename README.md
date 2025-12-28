# Architecture Overview:

# The Five Channels:

    The AXI4-Lite protocol is based on five independent channels, each utilizing a two-way VALID/READY handshake for reliable data transfer.
    
  # Write Channels (Master to Slave)
  
    Write Address (AW): AWVALID, AWADDR, AWREADY
    Write Data (W): WVALID, WDATA, WSTRB, WREADY
  # Read Channels (Master to Slave)
    Read Address (AR): ARVALID, ARADDR, ARREADY
    Read Data (R): RVALID, RDATA, RRESP, RREADY
  # Response Channels (Slave to Master)
    Write Response (B): BVALID, BRESP, BREADY


  # Implementation Details: Parameters and Memory

## Configurable Parameters

The module allows for flexibility through specific configurable parameters, primarily controlling bus dimensions and byte lanes.

| Parameter | Description | Default Value |
| :--- | :--- | :--- |
| **`ADDRESS_WIDTH`** | Defines the width of the address bus. | 32 |
| **`DATA_WIDTH`** | Defines the width of the data bus (supports 32 or 64). | 32 |
| **`STRB_WIDTH`** | Number of byte-lanes (Calculated as `DATA_WIDTH / 8`). | 4 |

---

## Internal Memory Structure

A simple register array serves as the memory space for the Control and Status Registers (CSRs). The structure allows for variable data and address widths based on the parameters defined above.

** Logic Definition: **
```systemverilog
  logic [DATA_WIDTH-1:0] mem[ADDRESS_WIDTH-1:0]

