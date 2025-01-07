export BasicRay

"""
    struct BasicRay{ND, T} <: AbstractRay{ND, T}

A basic implementation of a ray in `ND` dimensions with arithmetic type `T`.

Only stores a current position and a direction.
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

"""
    BasicRay{ND, T}(pos, dir) where {ND, T}
    BasicRay(pos, dir)

Construct a `BasicRay{ND, T}` with position `pos` and direction `dir`.
With the second signature, `ND` and `T` are determined automatically from the arguments.

The direction is normalized before costruction.

Both arguments should be vectors of length `ND` and element type `T`.
Both are copied so that later changes to the objects passed as arguments don't affect the constructed ray.
"""
BasicRay(pos, dir) = BasicRay{length(pos), promote_type(eltype(pos), eltype(dir))}(pos, dir)

position(ray::BasicRay) = ray.pos
direction(ray::BasicRay) = ray.dir
