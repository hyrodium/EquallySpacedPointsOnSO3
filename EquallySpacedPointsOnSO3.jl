using Rotations
using LinearAlgebra
using Statistics
using StaticArrays
using Random

using Plots
using GeometryBasics

plotly()

ElType = RotMatrix3{Float64}

function distance(R1::ElType, R2::ElType)
    # return angle(MRP(R1/R2))
    return rotation_angle(R1/R2)
end

function rand_SO3()
    return rand(ElType)
end

function rand_SO3(n::Integer)
    return [rand_SO3() for _ in 1:n]
end

function energy(p1::ElType, p2::ElType)
    return 1/distance(p1,p2)
end

function energy(ps::Vector{ElType}, i::Integer)
    l = length(ps)
    E = 0.0
    for j in 1:l
        if i==j
            continue
        end
        E += energy(ps[i],ps[j])
    end
    return E
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

function update(R::ElType)
    u = randn()/1000
    v = randn()/1000
    w = randn()/1000
    return R*MRP(u,v,w)
end

function update(ps::Vector{ElType})
    i = rand(1:length(ps))
    E_old = energy(ps,i)
    ps′ = copy(ps)
    ps′[i] = update(ps′[i])
    E_new = energy(ps′,i)
    if E_new < E_old
        return ps′
    else
        return ps
    end
end


Random.seed!(42)
# generate initial points
# ps = rand_SO3(2)
# ps = rand_SO3(12)
ps = rand_SO3(24)
# ps = rand_SO3(60)

# minimize energy
for i in 1:1000000
    ps = update(ps)
end
energy(ps)

# check angles between rotations
[rad2deg(rotation_angle(R1/R2)) for R1 in ps, R2 in ps]

[rad2deg(rotation_angle(R1/R2)) for R1 in qs, R2 in qs]

# set origin
ps = [p/ps[1] for p in ps]

# check group structure
i = 4
ps[i]^2
ps[i]^3
ps[i]^4

energy(ps)

# to compare with polyhedral group
M1 = [1 0 0;0 1 0;0 0 1]
M2 = [1 0 0;0 -1 0;0 0 -1]
M3 = [-1 0 0;0 1 0;0 0 -1]
M4 = [-1 0 0;0 -1 0;0 0 1]

M5 = [0 1 0;0 0 1;1 0 0]
M6 = [0 1 0;0 0 -1;-1 0 0]
M7 = [0 -1 0;0 0 1;-1 0 0]
M8 = [0 -1 0;0 0 -1;1 0 0]

M9 = [0 0 1;1 0 0;0 1 0]
M10 = [0 0 1;-1 0 0;0 -1 0]
M11 = [0 0 -1;1 0 0;0 -1 0]
M12 = [0 0 -1;-1 0 0;0 1 0]

qs = RotMatrix3{Float64}[M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12]
energy(qs)

