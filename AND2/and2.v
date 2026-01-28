module and2 (
  input wire a,
  input wire b,
  output wire y
  );

  assign y = a & b;

endmodule

module or2 (
  input wire a,
  input wire b,
  output wire y
  );

  assign y = a | b;

endmodule

module nand2 (
  input wire a,
  input wire b,
  output wire y
  );
  
  assign y = !(a & b);

endmodule

module nor2 (
  input wire a,
  input wire b,
  output wire y
);
  assign y = !(a | b);
endmodule

module not1 (
  input wire a,
  output wire y
);
  assign y = !(a);
endmodule

module xor2 (
  input wire a,
  input wire b,
  output wire y
);
  assign y = (a ^ b);
endmodule

`timescale 1ns/1ps
module basic2_tb;
    reg tb_a;
    reg tb_b;
    wire tb_and, tb_or, tb_nand, tb_nor, tb_not, tb_xor;

    and2  dut1 (.a(tb_a), .b(tb_b), .y(tb_and));
    or2   dut2 (.a(tb_a), .b(tb_b), .y(tb_or));
    nand2 dut3 (.a(tb_a), .b(tb_b), .y(tb_nand));
    nor2  dut4 (.a(tb_a), .b(tb_b), .y(tb_nor));
    not1  dut5 (.a(tb_a), 			.y(tb_not));
    nor2  dut6 (.a(tb_a), .b(tb_b), .y(tb_xor));

    initial begin
			tb_a <= 0; tb_b <= 0;
        #10 tb_a <= 0; tb_b <= 1;
        #10 tb_a <= 1; tb_b <= 0;
        #10 tb_a <= 1; tb_b <= 1;
        #10 tb_a <= 0; tb_b <= 0;
//        $finish;
    end
endmodule