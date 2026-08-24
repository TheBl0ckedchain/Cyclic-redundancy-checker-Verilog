module crc_serial_checker #(
    parameter integer WIDTH = 8,
    parameter [WIDTH-1:0] POLY = 8'h07
) (
    input  wire             clk,
    input  wire             rst_n,
    input  wire             clear,
    input  wire             bit_valid,
    input  wire             bit_in,
    output reg  [WIDTH-1:0] crc,
    output wire             crc_ok
);

wire feedback;

assign feedback = bit_in ^ crc[WIDTH-1];
assign crc_ok = (crc == {WIDTH{1'b0}});

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        crc <= {WIDTH{1'b0}};
    end else if (clear) begin
        crc <= {WIDTH{1'b0}};
    end else if (bit_valid) begin
        crc <= feedback ? ({crc[WIDTH-2:0], 1'b0} ^ POLY)
                        :  {crc[WIDTH-2:0], 1'b0};
    end
end

endmodule
