module RowEchelon

export rref

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
