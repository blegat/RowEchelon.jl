__precompile__()

module RowEchelon
using LinearAlgebra

export rref, rref!

function rref!(A::Matrix{T}, ɛ=T <: Union{Rational,Integer} ? 0 : eps(norm(A,Inf))) where T
    nr, nc = size(A)
    i = j = 1
    while i <= nr && j <= nc
        (m, mi) = findmax(abs.(A[i:nr,j]))
        mi = mi+i - 1
        if m <= ɛ
            if ɛ > 0
                A[i:nr,j] .= zero(T)
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

rrefconv(::Type{T}, A::Matrix) where {T} = rref!(copyto!(similar(A, T), A))

"""
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
"""
rref(A::Matrix{T}) where {T} = rref!(copy(A))
rref(A::Matrix{T}) where {T <: Complex} = rrefconv(ComplexF64, A)
rref(A::Matrix{ComplexF64}) = rref!(copy(A))
rref(A::Matrix{T}) where {T <: Union{Integer, Float16, Float32}} = rrefconv(Float64, A)
rref(A::AbstractMatrix) = rref(Matrix(A))
rref(A::Adjoint) = rref(Matrix(A))

include("RowEchelon_with_pivots.jl")

end # module
