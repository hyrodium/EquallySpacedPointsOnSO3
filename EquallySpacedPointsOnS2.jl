using Rotations
using LinearAlgebra
using Statistics
using StaticArrays

using Plots
using GeometryBasics

plotly()

ElType = SVector{3,Float64}

function distance(p1::ElType, p2::ElType)
    return norm(p1-p2)
end

function rand_S2()
    v = @SVector randn(3)
    return normalize(v)
end

function rand_S2(n::Integer)
    return [rand_S2() for _ in 1:n]
end

function energy(p1::ElType, p2::ElType)
    return 1/distance(p1,p2)
end

function energy(ps::Vector{ElType})
    l = length(ps)
    E = 0.0
    for i in 2:l
        for j in 1:i-1
            E += energy(ps[i],ps[j])
        end
    end
    return E
end

function update(p::ElType)
    v = @SVector randn(3)
    return normalize(p+v/10)
end

function stereographicprojection(u,v)
    SVector(2u/(u^2+v^2+1), 2v/(u^2+v^2+1), (u^2+v^2-1)/(u^2+v^2+1))
end

function update(ps::Vector{ElType})
    i = rand(1:length(ps))
    E_old = energy(ps)
    ps′ = copy(ps)
    ps′[i] = update(ps′[i])
    E_new = energy(ps′)
    if E_new < E_old
        return ps′
    else
        return ps
    end
end

# generate initial points
ps = rand_S2(20)

# minimize energy
for i in 1:1000000
    ps = update(ps)
end
println(energy(ps))

# plot points on a unit sphere
qs = [stereographicprojection(u,v) for u in -10:0.1:10, v in -10:0.1:10]
xs = [q[1] for q in qs]
ys = [q[2] for q in qs]
zs = [q[3] for q in qs]
surface(xs,ys,zs, alpha = 0.5)
scatter!(Point.(ps))
