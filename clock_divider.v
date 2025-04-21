
module clock_divider(
    input  wire clk,      
    input  wire reset,    
    output reg  tick      
);


    reg [19:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 20'd0;
            tick  <= 1'b0;
        end else if (count == 20'd999_999) begin
            count <= 20'd0;
            tick  <= 1'b1;
        end else begin
            count <= count + 1'b1;
            tick  <= 1'b0;
        end
    end

endmodule
