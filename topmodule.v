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



    always @(posedge clk) begin
        if (btnC) begin
            cnt <= 27'd0;
            tens <= 4'd0;
            ones <= 4'd0;
        end
        
        else if (tick) begin
            cnt <= 27'd0;
            if (ones == 4'd9) begin
                ones <= 4'd0;
                if (tens == 4'd9) tens <= 4'd0;
                else              tens <= tens + 4'd1;
            end
            else ones <= ones + 4'd1;
        end
        
        else begin
        
            cnt <= cnt + 1;
            
        end
    end

    // Displaying the values
    
    // Infinite counter
    reg [15:0] refresh = 16'd0;
    always @(posedge clk) refresh <= refresh + 16'd1;
    wire sel = refresh[15];
    
    wire [3:0] digit = sel ? tens : ones;
    hex7seg u_dec (.d(digit), .seg(seg));
    
    assign an = sel ? 4'b1101 : 4'b1110;
    assign dp = 1'b1;    // decimal point off (active-low)
    
    
      
endmodule