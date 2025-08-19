module CLA_tb();
    reg [63:0] A, B;
    reg cin;
    wire [63:0] sum;
    wire cout;

    CLA dut0 (
        .A(A), .B(B), .cin(cin),
        .sum(sum), .cout(cout)
    );

    initial begin
        $display("Time\tCin\tA\t\t\t\t\t\t\t\t\t\t\t\tB\t\t\t\t\t\t\t\t\t\t\t\tSum\t\t\t\t\t\t\t\t\t\t\t\tCout");
        $monitor("%0t\t%b\t%h\t%h\t%h\t%b", $time, cin, A, B, sum, cout);

        // Test case 1: Small values
        cin = 0;
        A = 64'd1;
        B = 64'd1;
        #5;

        // Test case 2: Carry-out generation
        cin = 0;
        A = 64'd50;
        B = 64'd20;
        #5;

        // Test case 3: With cin = 1
        cin = 1;
        A = 64'd100;
        B = 64'd200;
        #5;

        // Test case 4: Large numbers with no overflow
        cin = 0;
        A = 64'h0000_FFFF_FFFF_FFFF;
        B = 64'h0000_0000_0000_0001;
        #5;

        // Test case 5: Large numbers causing carry out
        cin = 0;
        A = 64'hFFFF_FFFF_FFFF_FFFF;
        B = 64'h0000_0000_0000_0001;
        #5;

        // Test case 6: A = 0, B = max, with cin = 1
        cin = 1;
        A = 64'd0;
        B = 64'hFFFF_FFFF_FFFF_FFFF;
        #5;

        // Test case 7: Random mid-range numbers
        cin = 0;
        A = 64'h1234_5678_ABCD_EF01;
        B = 64'h1111_1111_1111_1111;
        #5;

        // Test case 8: Both inputs zero
        cin = 0;
        A = 64'd0;
        B = 64'd0;
        #5;

        // Test case 9: Both inputs max
        cin = 0;
        A = 64'hFFFF_FFFF_FFFF_FFFF;
        B = 64'hFFFF_FFFF_FFFF_FFFF;
        #5;

        // Test case 10: One input alternating bits
        cin = 0;
        A = 64'hAAAAAAAA_AAAAAAAA;
        B = 64'h55555555_55555555;
        #5;

        $stop;
    end
endmodule
