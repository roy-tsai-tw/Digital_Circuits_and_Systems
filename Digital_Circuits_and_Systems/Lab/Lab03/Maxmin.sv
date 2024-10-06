module Maxmin #(
              parameter DATA_WIDTH = 8,
			  parameter COUNT_WIDTH = 4,
              parameter COUNT = 15
              )
			  (clk,
			   rst_n,
			   in_num,
			   in_valid,
			   out_max,
			   out_min,
			   out_valid
			   );

input                     clk;
input                     rst_n;
input  [(DATA_WIDTH-1):0] in_num;
input                     in_valid;
output [(DATA_WIDTH-1):0] out_max;
output [(DATA_WIDTH-1):0] out_min;
output                    out_valid;

logic [(COUNT_WIDTH-1):0] count_reg;
logic [(COUNT_WIDTH-1):0] count_wire;
logic [(DATA_WIDTH-1):0] max_reg, min_reg;
logic [(DATA_WIDTH-1):0] max_wire, min_wire;
logic out_valid_reg;
logic out_valid_wire;

//counter
assign count_wire = (in_valid)?(count_reg + 'd1):'d0;

always_ff@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		count_reg <= 'd0;
	else
		count_reg <= count_wire;
end

//output logic
assign out_valid_wire = (out_valid_reg)?1'b0:(count_reg == COUNT - 'd1);
assign max_wire = (!in_valid)?'d0:(((in_num > max_reg))?in_num:max_reg);
assign min_wire = (!in_valid)?'d255:(((in_num < min_reg))?in_num:min_reg);

always_ff@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		out_valid_reg <= 'd0;
	else
		out_valid_reg <= out_valid_wire;
end

always_ff@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		max_reg <= 'd0;
	else
		max_reg <= max_wire;
end

always_ff@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		min_reg <= 'd255;
	else
		min_reg <= min_wire;
end

assign out_valid = out_valid_reg;
assign out_max = max_reg;
assign out_min = min_reg;

endmodule