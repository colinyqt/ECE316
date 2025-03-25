`timescale 1ns / 1ps

module tb_time_multiplexing_main;

    reg clk;
    reg reset;
    reg [15:0] sw;
    wire [3:0] an;
    wire [6:0] sseg;
    wire slow_clk;

    // Instantiate the clock divider to generate the slow clock
    clk_div_disp clk_div_inst (
        .clk(clk),
        .reset(reset),
        .slow_clk(slow_clk) // Use the correct port name
    );
    
    // Instantiate the main time multiplexing module
    time_multiplexing_main uut (
        .clk(slow_clk), // Use the divided clock
        .reset(reset),
        .sw(sw),
        .an(an),
        .sseg(sseg)
    );
    
    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;
    
    // Test sequence
    initial begin
        reset = 1;
        sw = 16'h0000;
        #50;
        reset = 0;
        
        #5000 sw = 16'hFFFF;
        #5000 sw = 16'h0000;
        #5000 sw = 16'h4321;
        #5000 sw = 16'h000F;
        
        #5000;
        $finish;
    end
    
       
   initial begin
    $monitor("Time=%0t | an=%b | sseg=%b | sw=%h", $time, an, sseg, sw);
end

endmodule
