module sixty_four_bit_brentkung_tb;

    reg  [63:0] A, B;
    reg         cin;
    wire [63:0] sum;
    wire        cout;

    sixty_four_bit_brentkung uut (
        .A(A), .B(B), .cin(cin),
        .sum(sum), .cout(cout)
    );

    initial begin
        $display("Time\tcin\tA\t\t\t\tB\t\t\t\t|\tsum\t\t\t\tcout");
        $monitor("%4dns\t%b\t%h\t%h\t|\t%h\t%b", 
                 $time, cin, A, B, sum, cout);

        cin = 0;
        A = 64'h0000000000000000; B = 64'h0000000000000000; #10;
        A = 64'h00000000FFFFFFFF; B = 64'h0000000000000001; #10;
        A = 64'hFFFFFFFFFFFFFFFF; B = 64'h0000000000000001; #10;
        A = 64'hAAAAAAAAAAAAAAAA; B = 64'h5555555555555555; #10;
        A = 64'h0123456789ABCDEF; B = 64'hFEDCBA9876543210; #10;

        cin = 1;
        A = 64'h0000000000000000; B = 64'h0000000000000000; #10;
        A = 64'h0000000000000001; B = 64'h0000000000000001; #10;
        A = 64'hFFFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFFFFFFFF; #10;
        A = 64'h8000000000000000; B = 64'h8000000000000000; #10;

        $finish;
    end
endmodule
