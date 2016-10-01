using RowEchelon
using FactCheck

facts("Example from Wikipedia") do
    A = [1 3 -1;
         0 1  7]
    R = [1 0 -22;
         0 1   7]
    @fact isapprox(rref(A), R) --> true
end

facts("Example from Rosetta Code") do
    A = [ 1   2   -1   -4;
          2   3   -1   -11;
         -2   0   -3    22]
    R = [ 1   0   0   -8;
          0   1   0    1;
          0   0   1   -2]
    @fact isapprox(rref(A), R) --> true
end

facts("Magic Square") do
    A = [16  2   3  13;
         5  11  10   8;
         9   7   6  12;
         4  14  15   1]
    R = [1   0   0   1;
         0   1   0   3;
         0   0   1  -3;
         0   0   0   0]
    @fact isapprox(rref(A), R) --> true
end
