`timescale 1ns/1ps

module tb_crc_parallel_checker;
    reg clk;
    reg rst_n;
    reg clear;
    reg data_valid;
    reg [7:0] data_in;
    wire [7:0] crc;
    wire crc_ok;

    reg [7:0] payload [0:8];
    integer i;

    crc_parallel_checker #(
        .WIDTH(8),
        .DATA_WIDTH(8),
        .POLY(8'h07)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .clear(clear),
        .data_valid(data_valid),
        .data_in(data_in),
        .crc(crc),
        .crc_ok(crc_ok)
    );

    always #5 clk = ~clk;

    task send_byte;
        input [7:0] value;
        begin
            @(posedge clk);
            data_valid <= 1'b1;
            data_in <= value;
            @(posedge clk);
            data_valid <= 1'b0;
        end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        clear = 1'b0;
        data_valid = 1'b0;
        data_in = 8'h00;

        payload[0] = "1";
        payload[1] = "2";
        payload[2] = "3";
        payload[3] = "4";
        payload[4] = "5";
        payload[5] = "6";
        payload[6] = "7";
        payload[7] = "8";
        payload[8] = "9";

        repeat (2) @(posedge clk);
        rst_n <= 1'b1;

        for (i = 0; i < 9; i = i + 1) begin
            send_byte(payload[i]);
        end

        @(posedge clk);
        if (crc !== 8'hF4) begin
            $fatal(1, "Parallel CRC mismatch: expected F4 got %02h", crc);
        end

        send_byte(crc);

        @(posedge clk);
        if (!crc_ok) begin
            $fatal(1, "Parallel CRC check failed: remainder=%02h", crc);
        end

        $display("PASS: parallel CRC checker");
        $finish;
    end

endmodule
