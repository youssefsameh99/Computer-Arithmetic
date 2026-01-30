module booth_radix2 (
    input clk,
    input rst,
    input start,
    input signed [7:0] A,
    input signed [7:0] B,
    output reg signed [15:0] P,
    output reg done
);

reg signed [8:0] ACC;        
reg signed [7:0] Q;
reg Qm;
reg signed [8:0] M;          
reg [3:0] count;

reg signed [8:0] acc_next;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        ACC   <= 0;
        Q     <= 0;
        Qm    <= 0;
        M     <= 0;
        count <= 0;
        done  <= 0;
    end

    else if (start) begin
        ACC   <= 0;
        Q     <= B;
        Qm    <= 0;
        M     <= {A[7],A};   // sign-extend A
        count <= 8;
        done  <= 0;
    end

    else if (count != 0) begin

    acc_next = ACC;

    case ({Q[0],Qm})
        2'b01: acc_next = ACC + M;
        2'b10: acc_next = ACC - M;
    endcase

    {ACC,Q,Qm} <= $signed({acc_next,Q,Qm}) >>> 1;

    count <= count - 1;

    if (count == 1)
        done <= 1'b1;   // assert AFTER final shift completes
end
end

always @(*) begin
    // drop extra ACC bit
    P = {ACC[7:0], Q};
end

endmodule
