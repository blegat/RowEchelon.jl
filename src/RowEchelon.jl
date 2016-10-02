module RowEchelon

export rref

"""
    rref(A)
Compute the reduced row echelon form of the matrix A.
Since this algorithm is sensitive to numerical imprecision,
* Complex numbers are converted to Complex128
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
"""
function rref{T}(A::Matrix{T})
    nr, nc = size(A)
    if T <: Complex
        S = Complex128
    elseif T <: Union{Integer, Float16, Float32}
        S = Float64
    else
        S = T
    end
    U = copy!(similar(A, S), A)
    ɛ = S <: Rational ? 0 : eps(norm(U,Inf))
    i = j = 1
    while i <= nr && j <= nc
        (m, mi) = findmax(abs(U[i:nr,j]))
        mi = mi+i - 1
        if m <= ɛ
            if ɛ > 0
                U[i:nr,j] = 0
            end
            j += 1
        else
            for k=j:nc
                U[i, k], U[mi, k] = U[mi, k], U[i, k]
            end
            d = U[i,j]
            for k = j:nc
                U[i,k] /= d
            end
            for k = 1:nr
                if k != i
                    d = U[k,j]
                    for l = j:nc
                        U[k,l] -= d*U[i,l]
                    end
                end
            end
            i += 1
            j += 1
        end
    end
    U
end

end # module
