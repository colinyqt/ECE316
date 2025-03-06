`timescale 1ns / 1ps

module clk_div_disp(
    input clk,          
    input reset,       
    output slow_clk   
    );
    
    reg [2:0] COUNT;   
    
    assign slow_clk = COUNT[2]; 
    
    always @ (posedge clk) begin
        if (reset)
            COUNT <= 0;
        else
            COUNT <= COUNT + 1; 
    end  
endmodule