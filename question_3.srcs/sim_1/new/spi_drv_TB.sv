`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Kepler Communication Hiring Process 
// Engineer: Francisco Granda
// 
// Create Date: 05/09/2022 04:05:34 PM
// Design Name: spi_drv_TB
// Module Name: spi_drv_TB
// Project Name: 
// Target Devices: 
// Tool Versions: Vivado 2021.2
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module spi_drv_TB ();
  
  parameter CLK_DIVIDE = 4; 
  parameter SPI_MAXLEN = 18;
  parameter n_clks = 12;
  
  logic sresetn     = 1'b0;  
  logic SCLK;
  logic clk       = 1'b0;
  logic MOSI;
  logic [n_clks-1:0] tx_data = 0;
  logic start_cmd = 1'b0;
  logic spi_drv_rdy;
  //logic n_clks = 8;
  logic [n_clks-1:0] rx_miso;
  logic SS_N;

  // Clock Generators:
  always #(2) clk = ~clk; // 250 MHz

  // Instantiation of UUT
  spi_drv #(
        .CLK_DIVIDE(CLK_DIVIDE),
        .SPI_MAXLEN(SPI_MAXLEN),
        .n_clks(n_clks)
    )spi_drv_UUT (
        .clk(clk),
        .sresetn(sresetn),
        .start_cmd(start_cmd),
        .spi_drv_rdy(spi_drv_rdy),
        //.n_clks(n_clks),
        .tx_data(tx_data),
        .rx_miso(rx_miso),
        .SCLK(SCLK),
        .MOSI(MOSI),
        .MISO(MOSI), // send back 
        .SS_N(SS_N)
    );

  // Send pulse to start transaction
  task Transaction(input [n_clks-1:0] data);
    @(posedge clk);
    tx_data <= data;
    start_cmd <= 1'b1;
    @(posedge clk);
    start_cmd <= 1'b0;
    @(posedge spi_drv_rdy);
  endtask

  
  initial
    begin
      repeat(1) @(posedge clk);
      sresetn = 1'b0; // active low
      repeat(5) @(posedge clk);
      sresetn = 1'b1;
      
      // Test
      Transaction(12'hAAA); //Test 8'b10101010
      //Transaction(8'hAA); //Test 8'b10101010
      repeat(20) @(posedge clk);
      $finish();      
    end 

endmodule