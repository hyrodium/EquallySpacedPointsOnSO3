using Rotations

function distance(R1, R2)
    R = MRP(R1/R2)
    return sqrt(R.x^2+R.y^2+R.z^2)
end

## examples
r1 = rand(RotMatrix{3})
r2 = rand(RotMatrix{3})
r3 = rand(RotMatrix{3})

distance(r1,r1)
distance(r1,r2)
distance(r2,r1)
distance(r3*r1,r3*r2)
