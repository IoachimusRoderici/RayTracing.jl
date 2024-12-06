export Ray

"""
A basic implementation of a ray in ND dimensions.

Only has a current position and direction, with the presition given by the type T.
"""
struct BasicRay{ND, T <: AbstractFloat} <: AbstractRay{ND}
    pos::MVector{ND, T}
    dir::MVector{ND, T}

    BasicRay(pos, dir) = new{length(pos), eltype(pos)}(copy(pos), normalize(dir))
end

position(ray::BasicRay) = ray.pos
direction(ray::BasicRay) = ray.dir

function advance!(ray::BasicRay, distance)
    ray.pos .+= distance * ray.dir
end