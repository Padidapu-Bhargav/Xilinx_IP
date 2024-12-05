`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.12.2024 11:25:10
// Design Name: 
// Module Name: sin_cos
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sin_cos#(parameter Width = 16)( 
                input aclk,
                input phase_valid,
                input [Width-1:0]phase, // fixed 1.2.13 format 
                output sin_cos_valid,
                output [Width-1:0]cos,  // fixed 1.1.14 format
                output [Width-1:0]sin   // fixed 1.1.14 format
    );
   
// CORDIC IP instantiation  
 cordic_0 cordic_0_instance (
  .aclk(aclk),                                // input wire aclk
  .s_axis_phase_tvalid(phase_valid),  // input wire s_axis_phase_tvalid
  .s_axis_phase_tdata(phase),    // input wire [15 : 0] s_axis_phase_tdata
  .m_axis_dout_tvalid(sin_cos_valid),    // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata({sin,cos})      // output wire [31 : 0] m_axis_dout_tdata
);

endmodule
