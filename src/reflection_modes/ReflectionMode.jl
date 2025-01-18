public ReflectionMode
export reflect!

"""
    abstract type ReflectionMode

Abstract type to describe the way that rays bounce (reflect) on a surface.

Objects of this type, when passed to [`reflect!`](@ref), determine how the
ray is mutated (i.e. how a new direction is chosen, and what other data is mutated).
"""
abstract type ReflectionMode end

"""
    reflect!(ray::AbstractRay, mode::ReflectionMode, surface_data)

Reflect `ray` on the surface described by `mode` and `surface_data`.

Usually this will modify the direction of `ray`, and possibly other data
(for example, color).

The type and meaning of `surface_data` is defined by each concrete type of [`ReflectionMode`](@ref).
"""
function reflect! end