export SpecularReflection

"""
    struct SpecularReflection <: ReflectionMode

This [`ReflectionMode`](@ref) inverts rays with respect to a surface,
mutating only the ray's direction.
"""
struct SpecularReflection <: ReflectionMode end

"""
    reflect!(ray, ::SpecularReflection, normal)

Invert the direction of `ray` with respect to the given `normal` vector.

`normal` should be a unit vector.
"""
function reflect!(ray, ::SpecularReflection, normal)
    dir = direction(ray)
    dir .-= 2 * (dir ⋅ normal) * normal
    normalize!(dir)
end