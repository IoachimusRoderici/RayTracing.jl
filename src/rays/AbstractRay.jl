export AbstractRay, direction, advance!
public position # position is not exported to avoid nameclash with Base, an overload is added instead.

"""
    abstract type AbstractRay{ND, T <: AbstractFloat}

Represents a ray in `ND` dimensions that uses the type `T` for numeric calculations.

All rays have a position and a direction, and each concrete type may carry additional information.
"""
abstract type AbstractRay{ND, T <: AbstractFloat} end

"""
    Base.eltype(::Type{<:AbstractRay})
    Base.eltype(::AbstractRay)

Return the numeric type used by a ray object or a ray type.
"""
Base.eltype(::Type{<:AbstractRay{ND, T}}) where {ND, T} = T

"""
    Base.ndims(::Type{<:AbstractRay})
    Base.ndims(::AbstractRay)

Return the number of dimensions of a ray object or a ray type.
"""
Base.ndims(::Type{<:AbstractRay{ND, T}}) where {ND, T} = ND
Base.ndims(ray::AbstractRay) = Base.ndims(typeof(ray))

"""
    Base.position(ray)
    RayTracing.position(ray)

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
function advance!(ray, distance)
    # This implementation requires `position` to be mutable
    position(ray) .+= distance * direction(ray)
end
