`timescale 1ns / 1ps

// Created by : Noridel Herron
// Date 9/1/2025
// Scalable Adder

module adder_v #(parameter DATA_WIDTH = 4)(  // Chenge the value based on the bit width you like to test
    input  [DATA_WIDTH-1:0] A,
    input  [DATA_WIDTH-1:0] B,
    input                   Ci,
    output [DATA_WIDTH-1:0] Sum,
    output                  Cout
);

    wire [DATA_WIDTH:0] C;  
    assign C[0] = Ci;      
    
    // First Full Adder (bit 0)
    FullAdder_v FA0 (
        .A(A[0]),
        .B(B[0]),
        .Ci(C[0]),
        .Co(C[1]),
        .S(Sum[0])
    );

    // Generate FullAdders from bit 1 to DATA_WIDTH - 2
    genvar i;
    generate
        for (i = 1; i < DATA_WIDTH - 1; i = i + 1) begin :  FA_GEN 
            FullAdder_v FA (
                .A(A[i]),
                .B(B[i]),
                .Ci(C[i]),
                .Co(C[i+1]),
                .S(Sum[i])
            );
        end
    endgenerate

    // Last Full Adder (bit DATA_WIDTH - 1)
    FullAdder_v FA_last (
        .A(A[DATA_WIDTH-1]),
        .B(B[DATA_WIDTH-1]),
        .Ci(C[DATA_WIDTH-1]),
        .Co(Cout),
        .S(Sum[DATA_WIDTH-1])
    );

endmodule
