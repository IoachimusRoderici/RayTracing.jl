export Ray

"""
A basic implementation of a ray in `ND` dimensions with arithmetic type `T`.

Only has a current position and a direction.
"""
struct BasicRay{ND, T} <: AbstractRay{ND, T}
    pos::MVector{ND, T}
    dir::MVector{ND, T}

    BasicRay(pos, dir) = new{length(pos), eltype(pos)}(copy(pos), normalize(dir))
end

position(ray::BasicRay) = Point(ray.pos)
direction(ray::BasicRay) = SVector(ray.dir)

function advance!(ray::BasicRay, distance)
    ray.pos .+= distance * direction(ray)
end