
# The function rref(), but with the modification that it also returns the pivot vector

export rref_with_pivots, rref_with_pivots!

function rref_with_pivots!(A::Matrix{T}, ɛ=T <: Union{Rational,Integer} ? 0 : eps(norm(A,Inf))) where T
    nr, nc = size(A)
    pivots = Vector{Int64}()
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
            append!(pivots,j)
            i += 1
            j += 1
        end
    end
    return A, pivots
end

rref_with_pivots_conv(::Type{T}, A::Matrix) where {T} = rref_with_pivots!(copyto!(similar(A, T), A))

"""
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
"""
rref_with_pivots(A::Matrix{T}) where {T} = rref_with_pivots!(copy(A))
rref_with_pivots(A::Matrix{T}) where {T <: Complex} = rref_with_pivots_conv(ComplexF64, A)
rref_with_pivots(A::Matrix{ComplexF64}) = rref_with_pivots!(copy(A))
rref_with_pivots(A::Matrix{T}) where {T <: Union{Integer, Float16, Float32}} = rref_with_pivots_conv(Float64, A)

rref_with_pivots(A::AbstractMatrix) = rref_with_pivots(Matrix(A))
