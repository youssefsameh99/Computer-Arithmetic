module carry_operator(
    input g0 , g1 , p0 , p1,
    output G , P
);
assign G = g1 | (p1 & g0);
assign P = p1 & p0;
endmodule
