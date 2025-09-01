`timescale 1ns / 1ps

// Created by : Noridel Herron
// Date 9/1/2025
// FullAdder behavior

module FullAdder_v (
        input  A,
        input  B,
        input  Ci,
        output S,
        output Co
    );

	assign S  = A ^ B ^ Ci; 
	assign Co = (A & B) | (A & Ci) | (B & Ci); 
	
endmodule
