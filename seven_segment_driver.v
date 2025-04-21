
module seven_segment_driver(
    input  wire clk,      
    input  wire  reset,     
    input  wire [3:0] digit3,    
    input  wire [3:0] digit2,    
    input  wire [3:0] digit1,    
    input  wire [3:0] digit0,    
    output reg  [6:0] seg,      
    output reg  [3:0] an,        
    output reg  dp        
);
    reg [16:0] refresh_cnt;
    reg  [1:0] refresh_idx;

    always @(posedge clk) begin
        if (reset) begin
            refresh_cnt <= 17'd0;
            refresh_idx <= 2'd0;
        end else if (refresh_cnt == 17'd99_999) begin
            refresh_cnt <= 17'd0;
            refresh_idx <= refresh_idx + 1'b1;
        end else begin
            refresh_cnt <= refresh_cnt + 1'b1;
        end
    end

    function [6:0] digit_to_seg;
        input [3:0] d;
        begin
            case (d)
                4'd0: digit_to_seg = 7'b1000000;
                4'd1: digit_to_seg = 7'b1111001;
                4'd2: digit_to_seg = 7'b0100100;
                4'd3: digit_to_seg = 7'b0110000;
                4'd4: digit_to_seg = 7'b0011001;
                4'd5: digit_to_seg = 7'b0010010;
                4'd6: digit_to_seg = 7'b0000010;
                4'd7: digit_to_seg = 7'b1111000;
                4'd8: digit_to_seg = 7'b0000000;
                4'd9: digit_to_seg = 7'b0010000;
                default: digit_to_seg = 7'b1111111;
            endcase
        end
    endfunction


    always @(*) begin
        case (refresh_idx)
            2'd0: begin
                an  = 4'b0111;          
                seg = digit_to_seg(digit3);
                dp  = 1'b1;             
            end
            2'd1: begin
                an  = 4'b1011;         
                seg = digit_to_seg(digit2);
                dp  = 1'b0;          
            end
            2'd2: begin
                an  = 4'b1101;         
                seg = digit_to_seg(digit1);
                dp  = 1'b1;
            end
            2'd3: begin
                an  = 4'b1110;         
                seg = digit_to_seg(digit0);
                dp  = 1'b1;
            end
        endcase
    end

endmodule
