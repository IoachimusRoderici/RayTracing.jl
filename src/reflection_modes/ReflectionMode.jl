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
    reflect!(ray::AbstractRay, mode::ReflectionMode, geometric_data, material_data)

Reflect `ray` on the surface described by `mode`, `geometric_data`, and
`material_data`.

The type and meaning of `geometric_data` and `material_data` is defined by each
type of [`ReflectionMode`](@ref).
"""
function reflect! end