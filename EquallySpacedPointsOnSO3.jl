using Rotations
using LinearAlgebra

function distance2(R1, R2)
    R = MRP(R1/R2)
    d = R.x^2+R.y^2+R.z^2
    return min(d,1/d)
end

## examples
r1 = rand(RotMatrix{3})
r2 = rand(RotMatrix{3})
r3 = rand(RotMatrix{3})

distance2(r1,r1)
distance2(r1,r2)
distance2(r2,r1)
distance2(r3*r1,r3*r2)
