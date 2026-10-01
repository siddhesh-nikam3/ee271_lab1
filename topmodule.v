module top (
    input        clk,
    input        btnC,
    output [6:0] seg,
    output       dp,
    output [3:0] an
);
    reg [26:0] cnt = 27'd0;
    
    
    wire tick = (cnt == 27'd99_999_999);
    
    reg [3:0]  ones = 4'd0;
    reg [3:0]  tens = 4'd0;
    reg [3:0]  hund = 4'd0;
   
    always @(posedge clk) begin
        if (btnC) begin
            cnt <= 27'd0;
            tens <= 4'd0;
            ones <= 4'd0;
            hund <= 4'd0;
        end
        
        else if (tick) begin
            cnt <= 27'd0;
            if (ones == 4'd9) begin
                ones <= 4'd0;
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    if (hund == 4'd9) hund <= 4'd0;   // 999 -> 000
                    else                  hund <= hund + 4'd1;
                end
                else tens <= tens + 4'd1;
            end
            else ones <= ones + 4'd1;
        end
        else
            cnt <= cnt + 27'd1;
            end
            

    // Displaying the values
    
    // Infinite counter
    reg [16:0] refresh = 17'd0;
    always @(posedge clk) refresh <= refresh + 17'd1;
    wire [1:0] sel = refresh[16:15];
    
    reg [3:0] digit;
    reg [3:0] an_r;
    
    always @(*) begin
        case (sel)
            2'd0:    begin digit = ones;     an_r = 4'b1110; end   // rightmost
            2'd1:    begin digit = tens;     an_r = 4'b1101; end
            2'd2:    begin digit = hund;     an_r = 4'b1011; end
            default: begin digit = 4'd0;     an_r = 4'b1111; end   // all off
        endcase
    end
    hex7seg u_dec (.d(digit), .seg(seg));
    
    assign an = an_r;
    assign dp = 1'b1;    // decimal point off (active-low)
    
    
      
endmodule
