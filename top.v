
module top(
    input  wire        clk,       
    input  wire [4:0]  btn,       
    input  wire [15:0] sw,        
    output wire [6:0]  seg,       
    output wire [3:0]  an,        
    output wire        dp         
);

    wire       start_stop = btn[0];
    wire       reset_btn  = btn[1];
    wire [1:0] mode       = sw[1:0];
    wire [3:0] load_tens  = sw[9:6];
    wire [3:0] load_ones  = sw[5:2];

    wire tick;
    clock_divider clk_div (
        .clk   (clk),
        .reset (reset_btn),
        .tick  (tick)
    );

    wire [3:0] sec_tens, sec_ones, ms_tens, ms_ones;
    stopwatch_timer sw_timer (
        .clk           (clk),
        .reset         (reset_btn),
        .start_stop    (start_stop),
        .mode          (mode),
        .load_sec_tens (load_tens),
        .load_sec_ones (load_ones),
        .tick          (tick),
        .sec_tens      (sec_tens),
        .sec_ones      (sec_ones),
        .ms_tens       (ms_tens),
        .ms_ones       (ms_ones)
    );

    seven_segment_driver disp_drvr (
        .clk    (clk),
        .reset  (reset_btn),
        .digit3 (sec_tens),
        .digit2 (sec_ones),
        .digit1 (ms_tens),
        .digit0 (ms_ones),
        .seg    (seg),
        .an     (an),
        .dp     (dp)
    );

endmodule
