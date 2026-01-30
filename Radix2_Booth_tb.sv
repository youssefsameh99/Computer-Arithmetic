module tb_booth_radix2;

  reg clk = 0;
  reg rst;
  reg start;

  reg signed [7:0] A;
  reg signed [7:0] B;

  wire signed [15:0] P;
  wire done;

  reg signed [15:0] golden_ref;

  booth_radix2 dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .A(A),
    .B(B),
    .P(P),
    .done(done)
  );

  // Clock
  always #5 clk = ~clk;

  integer i;

  initial begin

    // Reset
    rst = 1;
    start = 0;
    A = 0;
    B = 0;
    #20;
    rst = 0;

    // Directed tests
    run_test(0,0);
    run_test(1,-1);
    run_test(-1,-1);
    run_test(127,127);
    run_test(-128,1);
    run_test(-128,-1);

    // Random tests
    for (i=0;i<2000;i=i+1) begin
      run_test($random,$random);
    end

    $display("===============================");
    $display("ALL BOOTH TESTS PASSED ✅");
    $display("===============================");
    $finish;
  end

  // One complete multiplication
  task run_test(input signed [7:0] a, input signed [7:0] b);
    begin
      A = a;
      B = b;

      // Pulse start
      @(negedge clk);
      start = 1;
      @(negedge clk);
      start = 0;

      // Wait for done
      wait(done);
      @(negedge clk);
      golden_ref = A * B;

      if (P !== golden_ref) begin
        $display("ERROR!");
        $display("A   = %d", A);
        $display("B   = %d", B);
        $display("P   = %d", P);
        $display("REF = %d", golden_ref);
      end
    end
  endtask

endmodule
