// 64-bit Brent-Kung Adder using clean generate blocks
module sixty_four_bit_brentkung (
    input  [63:0] A, B,
    input         cin,
    output [63:0] sum,
    output        cout
);

    wire [63:0] g, p;
    assign g = A & B;
    assign p = A ^ B;

    wire [64:0] C;
    assign C[0] = cin;

    wire [63:0] G [0:5];
    wire [63:0] P [0:5];

    // Stage 0: Initialize G and P
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : stage0
            assign G[0][i] = g[i];
            assign P[0][i] = p[i];
        end
    endgenerate

    // Prefix stages: only compute where j >= distance, skip others (auto pass-through)
    // D calculation is for distance , for stage 1 we combine every 2 adjacent pairs (distance 1) for , stage 2 we combine bits seperate by 2 and 
    //so on... 
    //we compute j>= D as its only valid with this condition (imagine if j = 5 and we are in stage 4 , there is no prev bit within this distance to combine )
    generate
        genvar s, j;
        for (s = 1; s < 6; s = s + 1) begin : prefix_stage
            for (j = 0; j < 64; j = j + 1) begin : prefix_bit
                localparam integer D = (1 << (s - 1));
                if (j >= D) begin : compute
                    carry_operator u (
                        .g0(G[s-1][j - D]),
                        .g1(G[s-1][j]),
                        .p0(P[s-1][j - D]),
                        .p1(P[s-1][j]),
                        .G(G[s][j]),
                        .P(P[s][j])
                    );
                end else begin : passthru
                    assign G[s][j] = G[s-1][j];
                    assign P[s][j] = P[s-1][j];
                end
            end
        end
    endgenerate

    // Carry calculation from stage 5
    generate
        for (i = 0; i < 64; i = i + 1) begin : carry_out
            assign C[i+1] = G[5][i] | (P[5][i] & C[i]);
        end
    endgenerate

    // Final sum computation
    generate
        for (i = 0; i < 64; i = i + 1) begin : final_sum
            assign sum[i] = p[i] ^ C[i];
        end
    endgenerate

    assign cout = C[64];
endmodule