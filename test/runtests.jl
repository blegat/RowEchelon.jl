using RowEchelon
using FactCheck

As = Vector{Matrix{Int}}()
Rs = Vector{Matrix{Int}}()
# Issue #518 of Julia Base
push!(As, [ 1  2  0   3;
            2  4  0   7])
push!(Rs, [ 1  2  0   0;
            0  0  0   1])
# Example from Wikipedia
push!(As, [ 1  3  -1;
            0  1   7])
push!(Rs, [ 1  0 -22;
            0  1   7])
# Example from Wikibooks
push!(As, [ 0  3 -6   6  4  -5;
            3 -7  8  -5  8   9;
            3 -9 12  -9  6  15])
push!(Rs, [ 1  0 -2   3  0 -24;
            0  1 -2   2  0  -7;
            0  0  0   0  1   4])
# Example from Rosetta Code
push!(As, [ 1  2 -1  -4;
            2  3 -1 -11;
           -2  0 -3  22])
push!(Rs, [ 1  0  0  -8;
            0  1  0   1;
            0  0  1  -2])
# Magic Square
push!(As, [16  2  3  13;
            5 11 10   8;
            9  7  6  12;
            4 14 15   1])
push!(Rs, [ 1  0  0   1;
            0  1  0   3;
            0  0  1  -3;
            0  0  0   0])


facts("Matrices of integers (treated as Float64)") do
    for (A,R) in zip(As,Rs)
        C = rref(A)
        @fact typeof(C) --> Matrix{Float64}
        @fact isapprox(C, R) --> true
    end
end

facts("Matrices of rationals") do
    for (A,R) in zip(As,Rs)
        B = Matrix{Rational{Int}}(A)
        C = rref(B)
        @fact typeof(C) --> Matrix{Rational{Int}}
        @fact C --> R
    end
end
