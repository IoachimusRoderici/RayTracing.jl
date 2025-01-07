# [Rays](@id rays_page)

A ray is a point object[^1] that moves in a straight line at constant velocity.
When rays intersect with the surface of an object, they "bounce" by changing their
direction in some way (for example, inverting their velocity vector with respect to
the object's surface).

[^1]: A point object is a small object that is treated as a dot to simplify calculations.

## The Ray Interface

Rays in this package are represented by subtypes of [`AbstractRay{ND, T}`](@ref).
All ray types have (at least) two parameters:

- `ND`: the number of dimensions that the ray exists in.
- `T <: AbstractFloat`: the numeric type used internally by the ray struct.

The following functions are defined for all ray types and comprise the public interface for rays:
- [`eltype`](@ref)
- [`ndims`](@ref)
- [`position`](@ref RayTracing.position)
- [`direction`](@ref)
- [`advance!`](@ref)
- [`reflect!`](@ref)
- TODO: add direction! function

Additional functions may exist for each ray type.

# BasicRay

TODO: docs for basic ray

# StepRecorder

TODO: docs for step recorder