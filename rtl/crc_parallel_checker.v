module crc_parallel_checker #(
    parameter integer WIDTH = 8,
    parameter integer DATA_WIDTH = 8,
    parameter [WIDTH-1:0] POLY = 8'h07
) (
    input  wire                   clk,
    input  wire                   rst_n,
    input  wire                   clear,
    input  wire                   data_valid,
    input  wire [DATA_WIDTH-1:0]  data_in,
    output reg  [WIDTH-1:0]       crc,
    output wire                   crc_ok
);

function [WIDTH-1:0] crc_next;
    input [WIDTH-1:0]      crc_in;
    input [DATA_WIDTH-1:0] data;
    reg [WIDTH-1:0]        c;
    reg                    feedback;
    integer                i;
begin
    c = crc_in;
    for (i = DATA_WIDTH-1; i >= 0; i = i - 1) begin
        feedback = data[i] ^ c[WIDTH-1];
        c = {c[WIDTH-2:0], 1'b0};
        if (feedback) begin
            c = c ^ POLY;
        end
    end
    crc_next = c;
end
endfunction

assign crc_ok = (crc == {WIDTH{1'b0}});

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        crc <= {WIDTH{1'b0}};
    end else if (clear) begin
        crc <= {WIDTH{1'b0}};
    end else if (data_valid) begin
        crc <= crc_next(crc, data_in);
    end
end

endmodule
