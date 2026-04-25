module fir_filter (
   input clk,
   input rst,
   input signed [7:0] x_in,
   output reg signed [15:0] y_out
);
   reg signed [7:0] shift_reg [0:3];
   wire signed [15:0] mul [0:3];
   wire signed [15:0] sum;
   
   // Individual parameters to bypass Icarus Verilog array parsing bugs
   // 64 decimal = 40 hex (matches your waveform)
   parameter signed [7:0] H0 = 64;
   parameter signed [7:0] H1 = 64;
   parameter signed [7:0] H2 = 64;
   parameter signed [7:0] H3 = 64;
   
   // Shift Register
   always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg[0] <= 0;
            shift_reg[1] <= 0;
            shift_reg[2] <= 0;
            shift_reg[3] <= 0;
        end else begin
            shift_reg[3] <= shift_reg[2];
            shift_reg[2] <= shift_reg[1];
            shift_reg[1] <= shift_reg[0];
            shift_reg[0] <= x_in;
        end
   end
   
   assign mul[0] = shift_reg[0] * H0;
   assign mul[1] = shift_reg[1] * H1;
   assign mul[2] = shift_reg[2] * H2;
   assign mul[3] = shift_reg[3] * H3;
   
   assign sum = mul[0] + mul[1] + mul[2] + mul[3];
   
   // Output calculation
   always @(posedge clk or posedge rst) begin
        if (rst)
            y_out <= 0;
        else
            y_out <= sum / 256;  
   end
endmodule
