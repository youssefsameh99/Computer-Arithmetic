module CLA(
    input  [63:0] A, B,
    input         cin,
    output [63:0] sum,
    output        cout
);
    wire [63:0] g, p;
    assign g = A & B;
    assign p = A ^ B;

    // Carry array: c[0] = cin, c[64] = final carry out
    wire [64:0] c;
    assign c[0] = cin;

    // Level 1: 16 CLA blocks for each 4-bit segment
    wire [15:0] G1, P1;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : CLA_4_BLOCKS
            carry_look_ahead_logic CLA4 (
                .cin(c[i*4]),
                .g0(g[i*4]),
                .p0(p[i*4]),
                .g1(g[i*4 + 1]),
                .p1(p[i*4 + 1]),
                .g2(g[i*4 + 2]),
                .p2(p[i*4 + 2]),
                .g3(g[i*4 + 3]),
                .p3(p[i*4 + 3]),
                .c1(c[i*4 + 1]),
                .c2(c[i*4 + 2]),
                .c3(c[i*4 + 3]),
                .c4(c[i*4 + 4]),
                .G(G1[i]),
                .P(P1[i])
            );
        end
    endgenerate

    // Level 2: 4 CLA blocks to handle carry across 4-bit blocks (every 16 bits)
    wire [3:0] G2, P2;

    generate
        for (i = 0; i < 4; i = i + 1) begin : CLA_16_BLOCKS
            carry_look_ahead_logic CLA16 (
                .cin(c[i*16]),
                .g0(G1[i*4]),
                .p0(P1[i*4]),
                .g1(G1[i*4 + 1]),
                .p1(P1[i*4 + 1]),
                .g2(G1[i*4 + 2]),
                .p2(P1[i*4 + 2]),
                .g3(G1[i*4 + 3]),
                .p3(P1[i*4 + 3]),
                .c1(c[i*16 + 4]),
                .c2(c[i*16 + 8]),
                .c3(c[i*16 + 12]),
                .c4(c[i*16 + 16]),
                .G(G2[i]),
                .P(P2[i])
            );
        end
    endgenerate

    // Level 3: Top-level CLA block for 64-bit carry generation
    wire G3, P3;

    carry_look_ahead_logic CLA64 (
        .cin(cin),
        .g0(G2[0]), .p0(P2[0]),
        .g1(G2[1]), .p1(P2[1]),
        .g2(G2[2]), .p2(P2[2]),
        .g3(G2[3]), .p3(P2[3]),
        .c1(c[16]),
        .c2(c[32]),
        .c3(c[48]),
        .c4(c[64]),
        .G(G3),
        .P(P3)
    );

    // Final sum and carry-out
    assign sum = p ^ c[63:0];
    assign cout = c[64];

endmodule
 