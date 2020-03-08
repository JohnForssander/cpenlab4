

module shuffling_array_modular_tb();


											reg reset;

											reg clk;
											reg [23:0] secret_key;

											wire [7:0] address;
											wire [7:0] data;
											wire wren;
											reg [7:0] q;

											//Decrypted memory RAM
											wire [7:0] address_d;
											wire [7:0] data_d;
											wire wren_d;
											
											//Encrypted memory ROM
											wire [7:0] address_m;
											reg [7:0] q_m;

shuffling_array_modular dut(
											reset,

											clk,
											secret_key,

											address,
											data,
											wren,
											q,

											//Decrypted memory RAM
											address_d,
											data_d,
											ren_d,
											
											//Encrypted memory ROM
											address_m,
											q_m
										);


initial begin

reset = 1'b0;
clk = 1'b0;
secret_key = 24'b0;
q = 8'b0;
q_m = 8'b11111111;

forever begin
clk = !clk; #1;
end
end
endmodule
