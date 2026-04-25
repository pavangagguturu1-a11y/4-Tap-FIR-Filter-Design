module testbench;
  reg clk;
  reg rst;
  reg signed [7:0] x_in;
  wire signed [15:0] y_out;
  
  // Instantiate the FIR filter
  fir_filter uut (
    .clk(clk),
    .rst(rst),
    .x_in(x_in),
    .y_out(y_out)
  );
  
  // Clock generation (10ns period)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  // Stimulus
  initial begin
    // Generate VCD file for EPWave
    $dumpfile("dump.vcd");
    $dumpvars(0, testbench);
    
    // Initialize
    rst = 1;
    x_in = 0;
    
    // Sequence to match the screenshot perfectly
    #10; 
    rst = 0;
    x_in = 8'ha;  // 10 dec
    
    #10 x_in = 8'h14; // 20 dec
    #10 x_in = 8'h1e; // 30 dec
    #10 x_in = 8'h28; // 40 dec
    #10 x_in = 8'h32; // 50 dec
    #10 x_in = 8'h3c; // 60 dec
    #10 x_in = 8'h46; // 70 dec
    #10 x_in = 8'h50; // 80 dec
    
    // Let it run for a few more cycles to flush the pipeline
    #40 $finish;
  end
endmodule
