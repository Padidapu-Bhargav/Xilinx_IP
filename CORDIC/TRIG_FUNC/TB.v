`timescale 1ns / 1ps

module sin_cos_TB();

parameter Width = 16;
reg [1:0]c_state,n_state;

parameter IDLE = 2'd0;
parameter UP = 2'd1;
parameter DOWN = 2'd2;

reg clk;
reg rst;
reg phase_valid;
reg signed [Width-1:0]phase; // fixed 1.2.13 format 
wire sin_cos_valid;
wire [Width-1:0]cos;  // fixed 1.1.14 format
wire [Width-1:0]sin;  // fixed 1.1.14 format

reg signed [15:0]P_PI = 16'b0110_0100_1000_1000;
reg signed [15:0]N_PI = 16'b1001_1011_0111_1000;
localparam phase_inc = 256;
localparam clk_period = 10;


// module instantiation
sin_cos #(.Width(Width)) DUT( 
                .aclk(clk),
                .phase_valid(phase_valid),
                .phase(phase), 
                .sin_cos_valid(sin_cos_valid),
                .cos(cos),  
                .sin(sin));

initial begin
    c_state = 'd0;
    n_state = 'd0;
    phase_valid = 'd0;
end

initial begin
    clk = 1'b0;
    rst = 1'b1;
    rst = #(clk_period*3)'b0;
end

always begin
    #(clk_period/2) clk =  ~clk;
end

/*
// -pi to pi with increment of phase_inc and then pi to -pi without decrement 
always@(posedge clk) begin
    if(rst) begin
        phase_valid <= 'd0;
        phase <= N_PI;
    end
    else begin
        phase_valid <= 'd1; 
        if(phase + phase_inc == P_PI  )   phase <= N_PI; 
        else  phase <= phase + phase_inc;
        
    end
    
end */

// -pi to pi with increment of phase_inc and then pi to -pi with decrement of phase_inc
always@(posedge clk) begin
    if(rst) c_state <= IDLE;
    else c_state <= n_state;
end

always@(*) begin
    case(c_state)
        IDLE : begin
            n_state <= UP;
        end
        UP: begin
            if(phase +  phase_inc >= P_PI) n_state = DOWN;
            else n_state = UP;
        end
        DOWN: begin
            if(phase +  phase_inc <= N_PI) n_state = UP;
            else n_state = DOWN;
        end
    endcase
end

always@(posedge clk) begin
    case(c_state)
        IDLE : begin
            phase_valid <= 'd0;
            phase <= N_PI;
        end
        UP: begin
            phase_valid = 'd1;
            phase = phase + phase_inc;
        end
        DOWN: begin
            phase_valid = 'd1;
            phase = phase - phase_inc;
        end
    endcase

end 

endmodule 
