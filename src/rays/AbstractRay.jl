export AbstractRay, direction, advance!, reflect!
#export position # position is not exported to avoid nameclash with Base, an overload is added instead.

"""
    abstract type AbstractRay{ND, T <: AbstractFloat}

Represents a ray in `ND` dimensions.

A ray has a position and a direction, and may carry additional information.

`T` is the type used for numeric calculation.
"""
abstract type AbstractRay{ND, T <: AbstractFloat} end

Base.eltype(::Type{<:AbstractRay{ND, T}}) where {ND, T} = T
Base.ndims(::Type{<:AbstractRay{ND, T}}) where {ND, T} = ND
Base.ndims(ray::AbstractRay) = Base.ndims(typeof(ray))

"""
    position(ray)

Return the current position of the ray, possibly as a mutable reference.
"""
function position end
Base.position(ray::AbstractRay) = position(ray)

"""
    direction(ray)

Return the current direction of the ray, possibly as a mutable reference.
"""
function direction end

"""
    advance!(ray, distance)

Advances the ray by the given `distance` in its current direction.
"""
function advance!(ray::AbstractRay, distance)
    # This implementation requires `position` to be mutable
    position(ray) .+= distance * direction(ray)
end

"""
    reflect!(ray, normal)

Invert the direction of the ray with respect to the given `normal` vector.
"""
function reflect!(ray::AbstractRay, normal)
    # This implementation requires `direction` to be mutable
    dir = direction(ray)
    dir .-= 2 * (dir ⋅ normal) * normal
    normalize!(dir)
end
