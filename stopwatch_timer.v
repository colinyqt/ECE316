// stopwatch_timer.v
// Single-process FSM with BCD-load clamping for countdown stopwatch/timer
module stopwatch_timer(
    input  wire clk,            
    input  wire reset,          
    input  wire start_stop,     
    input  wire [1:0] mode,           
    input  wire [3:0] load_sec_tens,  
    input  wire [3:0] load_sec_ones,  
    input  wire tick,           
    output reg  [3:0] sec_tens,       
    output reg  [3:0] sec_ones,       
    output reg  [3:0] ms_tens,        
    output reg  [3:0] ms_ones         
);
    //make sure no funny inputs
    wire [3:0] init_sec_tens = (load_sec_tens <= 4'd9) ? load_sec_tens : 4'd0;
    wire [3:0] init_sec_ones = (load_sec_ones <= 4'd9) ? load_sec_ones : 4'd0;

    // Internal state
    reg running;
    reg prev_start;

    always @(posedge clk) begin

        prev_start <= start_stop;

        if (reset) begin
            running <= 1'b0;
            case (mode)
                2'b00: begin
                    sec_tens  <= 4'd0; sec_ones <= 4'd0;
                    ms_tens   <= 4'd0; ms_ones  <= 4'd0;
                end
                2'b01: begin
                    sec_tens  <= init_sec_tens;
                    sec_ones  <= init_sec_ones;
                    ms_tens   <= 4'd0; ms_ones  <= 4'd0;
                end
                2'b10: begin
                    sec_tens  <= 4'd9; sec_ones <= 4'd9;
                    ms_tens   <= 4'd9; ms_ones  <= 4'd9;
                end
                2'b11: begin
                    sec_tens  <= init_sec_tens;
                    sec_ones  <= init_sec_ones;
                    ms_tens   <= 4'd9; ms_ones  <= 4'd9;
                end
            endcase

        end else begin

            if (~prev_start & start_stop)
                running <= ~running;

            if (running && tick) begin
                if (mode[1] == 1'b0) begin
                    if (ms_ones < 9) begin
                        ms_ones <= ms_ones + 1;
                    end else begin
                        ms_ones <= 4'd0;
                        if (ms_tens < 9) begin
                            ms_tens <= ms_tens + 1;
                        end else begin
                            ms_tens <= 4'd0;
                            if (sec_ones < 9) begin
                                sec_ones <= sec_ones + 1;
                            end else begin
                                sec_ones <= 4'd0;
                                if (sec_tens < 9) begin
                                    sec_tens <= sec_tens + 1;
                                end else begin
                                    sec_tens <= 4'd9;
                                    sec_ones <= 4'd9;
                                    ms_tens  <= 4'd9;
                                    ms_ones  <= 4'd9;
                                    running  <= 1'b0;
                                end
                            end
                        end
                    end
                end else begin

                    if (ms_ones > 0) begin
                        ms_ones <= ms_ones - 1;
                    end else begin
                        ms_ones <= 4'd9;
                        if (ms_tens > 0) begin
                            ms_tens <= ms_tens - 1;
                        end else begin
                            ms_tens <= 4'd9;
                            if (sec_ones > 0) begin
                                sec_ones <= sec_ones - 1;
                            end else begin
                                sec_ones <= 4'd9;
                                if (sec_tens > 0) begin
                                    sec_tens <= sec_tens - 1;
                                end else begin
                                    sec_tens <= 4'd0;
                                    sec_ones <= 4'd0;
                                    ms_tens  <= 4'd0;
                                    ms_ones  <= 4'd0;
                                    running  <= 1'b0;
                                end
                            end
                        end
                    end
                end
            end
        end
    end

endmodule
