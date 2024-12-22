export AbstractRay, direction, advance!
#export position # position is not exported to avoid nameclash with Base, an overload is added instead.

"""
Represents a ray in `ND` dimensions.

A ray has a position and a direction, and may carry additional information.

`T` is the type used for numeric calculation.
"""
abstract type AbstractRay{ND, T <: AbstractFloat} end

Base.eltype(::Type{<:AbstractRay{ND, T}}) where {ND, T} = T
Base.ndims(::Type{<:AbstractRay{ND, T}}) where {ND, T} = ND

"""
position(ray)

Return the current position of the ray.
"""
function position end
Base.position(ray::AbstractRay) = position(ray)

"""
direction(ray)

Return the current direction of the ray.
"""
function direction end

"""
advance!(ray, distance)

Advances the ray by the given distance int its current direction.
"""
function advance! end
