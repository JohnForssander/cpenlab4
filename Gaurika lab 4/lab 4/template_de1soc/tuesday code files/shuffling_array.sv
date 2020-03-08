

module shuffling_array(
input logic clk,
input logic [23:0] secret_key,
output logic done_shuffling_array
);

parameter [7:0] keylength = 8'b00000011;

enum {initialize_array, idle, read_si, compute_j, read_sj, write_si, write_sj, 
		turn_off_write, increment_i, delay_one, delay_two, delay_two_two, delay_one_one} state;

reg [7:0] j, which_key, i,readdata_si, readdata_sj, address, data;
reg [8:0] counter = 9'b0;
reg wren, start_shuffling_array;
wire [7:0] q, mod_temp;

//calculations and instantiations outside fsm

s_memory read_smem(.address(address),.clock(clk),.data(data),.wren(wren),.q(q));

assign mod_temp = (i % keylength);

always_ff@(posedge clk) begin
 case(mod_temp)
	8'b00000000: which_key <= secret_key[23:16];
	8'b00000001: which_key <= secret_key[15:8];
	8'b00000010: which_key <= secret_key[7:0];
	default which_key <= secret_key[7:0];
 endcase
end

	 
always_ff@(posedge clk) begin

	case(state)
	
	initialize_array: begin if (counter <= 9'b11111111) begin
											address <= counter;
											data <= counter;
											counter <= counter + 1'b1;
											wren <= 1'b1; 
											start_shuffling_array <= 1'b0;
											state <= initialize_array; end
											
							else begin 	wren <= 1'b0; 
											start_shuffling_array <= 1'b1; 
											state <= idle;  end 
							end

	
	idle: 				begin if(start_shuffling_array) begin
										i <= 8'b0;
										j <= 8'b0;
										start_shuffling_array <= 1'b0;
										state <= read_si; end
									else state <= idle; end

									
	read_si: 			begin done_shuffling_array = 1'b0;
									wren = 1'b0; //write is off, so read is on
									address <= i;
									state <= delay_one; end
									
	delay_one:			state <= delay_one_one;
	
	delay_one_one:		begin readdata_si <= q;
									state <= compute_j; end
	
	compute_j:			begin j <= (j + readdata_si + which_key ); //j = (j + s[i] + secret_key[i % keylength] )
									state <= read_sj; end
	
	read_sj: 			begin address <= j;
									state <= delay_two; end
									
	delay_two: 			state <= delay_two_two;

	delay_two_two: 	begin readdata_sj <= q;
									state <= write_si; end
	 
	write_si: 			begin	wren <= 1'b1; //turning write enable on
									address <= i;
									data <= readdata_sj;
									state <= write_sj; end
	
	write_sj: 			begin address <= j;
									data <= readdata_si;
									state <= turn_off_write; end
	
	turn_off_write: 	begin wren = 1'b0;
									state <= increment_i; end
									
	increment_i: 		begin if (i < 8'b11111111) begin //counter < 255
											i <= i + 1'b1;
											state <= read_si; end
									else 	begin done_shuffling_array = 1'b1;  
											state <= idle; end
							end
							
	default state <= initialize_array;
	endcase
	
end


/*
   // shuffle the array based on the secret key.  You will build this in Task 2 
  j = 0    
  for i = 0 to 255 {
	j = (j + s[i] + secret_key[i % keylength] )  //keylength is 3 in our impl.     
	swap values of s[i] and s[j]    
	}    // compute one byte per character in the encrypted message.  You will build this in Task 2   
*/


endmodule
