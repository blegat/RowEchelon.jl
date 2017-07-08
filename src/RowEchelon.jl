__precompile__()

module RowEchelon

export rref, rref!

function rref!{T}(A::Matrix{T}, ɛ=T <: Union{Rational,Integer} ? 0 : eps(norm(A,Inf)))
    nr, nc = size(A)
    i = j = 1
    while i <= nr && j <= nc
        (m, mi) = findmax(abs.(A[i:nr,j]))
        mi = mi+i - 1
        if m <= ɛ
            if ɛ > 0
                A[i:nr,j] = 0
            end
            j += 1
        else
            for k=j:nc
                A[i, k], A[mi, k] = A[mi, k], A[i, k]
            end
            d = A[i,j]
            for k = j:nc
                A[i,k] /= d
            end
            for k = 1:nr
                if k != i
                    d = A[k,j]
                    for l = j:nc
                        A[k,l] -= d*A[i,l]
                    end
                end
            end
            i += 1
            j += 1
        end
    end
    A
end

rrefconv{T}(::Type{T}, A::Matrix) = rref!(copy!(similar(A, T), A))

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
rref{T}(A::Matrix{T}) = rref!(copy(A))
rref{T <: Complex}(A::Matrix{T}) = rrefconv(Complex128, A)
rref(A::Matrix{Complex128}) = rref!(copy(A))
rref{T <: Union{Integer, Float16, Float32}}(A::Matrix{T}) = rrefconv(Float64, A)

end # module
