# Reduced Row Echelon form computation

| **Build Status** |
|:----------------:|
| [![Build Status][build-img]][build-url] [![Build Status][winbuild-img]][winbuild-url] |
| [![Coveralls branch][coveralls-img]][coveralls-url] [![Codecov branch][codecov-img]][codecov-url] |

This small package contains the functions `rref` and `rref!`.
The code was initially part of Julia and was developed by Jeff Bezanson (see [here](https://github.com/JuliaLang/julia/pull/9804)).

[build-img]: https://travis-ci.org/blegat/RowEchelon.jl.svg?branch=master
[build-url]: https://travis-ci.org/blegat/RowEchelon.jl
[winbuild-img]: https://ci.appveyor.com/api/projects/status/h4q97x5fnhx20wnk/branch/master?svg=true
[winbuild-url]: https://ci.appveyor.com/project/blegat/rowechelon-jl/branch/master
[coveralls-img]: https://coveralls.io/repos/blegat/RowEchelon.jl/badge.svg?branch=master&service=github
[coveralls-url]: https://coveralls.io/github/blegat/RowEchelon.jl?branch=master
[codecov-img]: http://codecov.io/github/blegat/RowEchelon.jl/coverage.svg?branch=master
[codecov-url]: http://codecov.io/github/blegat/RowEchelon.jl?branch=master

Example of computing `rref_with_pivots` :

rref_with_pivots(A)

Compute the reduced row echelon form of the matrix A together with the
position of the pivots.
Since this algorithm is sensitive to numerical imprecision,
* Complex numbers are converted to ComplexF64
* Integer, Float16 and Float32 numbers are converted to Float64
* Rational are kept unchanged

```jldoctest
julia> rref_with_pivots([ 1  2 -1  -4;
              2  3 -1 -11;
             -2  0 -3  22])
3×4 Array{Float64,2}:
 1.0  0.0  0.0  -8.0
 0.0  1.0  0.0   1.0
 0.0  0.0  1.0  -2.0
 Int64[3]:
 1
 2
 3

julia> rref_with_pivots([16  2  3  13;
              5 11 10   8;
              9  7  6  12;
              4 14 15   1])
4×4 Array{Float64,2}:
 1.0  0.0  0.0   1.0
 0.0  1.0  0.0   3.0
 0.0  0.0  1.0  -3.0
 0.0  0.0  0.0   0.0
 Int64[3]:
 1
 2
 3

julia> rref_with_pivots([ 1  2  0   3;
              2  4  0   7])
2×4 Array{Float64,2}:
 1.0  2.0  0.0  0.0
 0.0  0.0  0.0  1.0
 Int64[3]:
 1
 4
```

Example of computing `rref` :

rref(A)

Compute the reduced row echelon form of the matrix A.
Since this algorithm is sensitive to numerical imprecision,
* Complex numbers are converted to ComplexF64
* Integer, Float16 and Float32 numbers are converted to Float64
* Rational are kept unchanged

```jldoctest
julia> rref([ 1  2 -1  -4;
              2  3 -1 -11;
             -2  0 -3  22])
3×4 Array{Float64,2}:
 1.0  0.0  0.0  -8.0
 0.0  1.0  0.0   1.0
 0.0  0.0  1.0  -2.0

julia> rref([16  2  3  13;
              5 11 10   8;
              9  7  6  12;
              4 14 15   1])
4×4 Array{Float64,2}:
 1.0  0.0  0.0   1.0
 0.0  1.0  0.0   3.0
 0.0  0.0  1.0  -3.0
 0.0  0.0  0.0   0.0

julia> rref([ 1  2  0   3;
              2  4  0   7])
2×4 Array{Float64,2}:
 1.0  2.0  0.0  0.0
 0.0  0.0  0.0  1.0
```