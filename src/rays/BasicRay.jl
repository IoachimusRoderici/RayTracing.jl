export BasicRay

"""
A basic implementation of a ray in `ND` dimensions with arithmetic type `T`.

Only has a current position and a direction.
"""
struct BasicRay{ND, T} <: AbstractRay{ND, T}
    pos::MVector{ND, T}
    dir::MVector{ND, T}

    function BasicRay{ND, T}(pos, dir) where {ND, T}
        normalized_dir = normalize(dir)
        @assert norm(normalized_dir) ≈ 1 "Could not normalize dir: got $normalized_dir."
        new{ND, T}(copy(pos), normalized_dir)
    end
end

BasicRay(pos, dir) = BasicRay{length(pos), promote_type(eltype(pos), eltype(dir))}(pos, dir)

position(ray::BasicRay) = ray.pos
direction(ray::BasicRay) = ray.dir

function advance!(ray::BasicRay, distance)
    ray.pos .+= distance * direction(ray)
end