module carry_look_ahead_logic(
    input cin,       
    input g0, p0, g1, p1, g2, p2, g3, p3, 
    output c1, c2, c3, c4,              
    output G, P                 
);

    assign P = p3 & p2 & p1 & p0;
    assign G = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0);
    assign c1 = g0 | (p0 & cin);
    assign c2 = g1 | (p1 & g0) | (p1 & p0 & cin);
    assign c3 = g2 | (p2 & g1) | (p2 & p1 & g0) | (p2 & p1 & p0 & cin);
    assign c4 = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0) | (p3 & p2 & p1 & p0 & cin);

endmodule
