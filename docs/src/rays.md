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

Additional functions may exist for each ray type.

There is a ray type, [`BasicRay`](@ref), that provides the most minimal implementation of this
interface. More complex ray types can then be built by adding data or behavior to `BasicRay`.
See for example [`RayWithData`](@ref) and [`StateRecorder`](@ref), which can be used to define
ray types that carry usefull data.

## Reflection Modes

Rays can interact with surfaces. The interaction between a ray and a surface can actually be
any combination of four effects: absorption, reflection, refraction and fluorescence. However,
this library refers to all of these effects as "reflection".

A reflection mode is a description of what happens to a ray when it hits a surface. Anything
you want can happen to a ray when it hits a surface, you just have to create a reflection mode
with the desired behavior.

Reflection modes are subtypes of [`ReflectionMode`](@ref), and they add methods to the
[`reflect!`](@ref) function to describe what happens to the ray. This function takes as arguments
the ray itself, the reflection mode, some data describing the geometry of the surface that the ray
is reflecting on, and some data describing the material of the surface. Reflection modes can use
all this information to perform the necessary operations on the ray.

The most commonly used reflection mode is probably [`SpecularReflection`](@ref), which inverts
the direction of the ray with respect to the surface, creating a perfect, mirror-like reflection.
The only information about the surface that this reflection mode uses is the normal vector, which
must be passed as the geometric data to `reflect!`.

Each reflection mode may require specific information to be passed as the geometric of material data.

Usually, more than one thing happens to a ray when reflecting on a surface. For example, the ray's
direction might change as described by `SpecularReflection`, but also some data carried by the ray may
be mutated in a way described by [`MaterialDataOperation`](@ref). Think of a ray of light carrying a
color: the ray's direction must be reflected, and also the color must change in a way that depends
of the material of the surface.

For these cases where multiple existing reflection modes must be used at the same time,
[`CombinedReflectionModes`](@ref) can be used.

## Ray Sources

A single ray will usually not get you very far on a ray tracing simulation. You probably want to trace
many rays that are aligned with the pixels of an image, or that follow some probability distribution,
or whatever. Thats where ray sources come in handy.

A ray source is just some iterable object that produces a sequence of rays.

For example, the source [`BackwardsCameraRays`](@ref) produces a matrix of rays where each ray points to
the direction viewed by the corresponding pixel on a camera image. This is useful for backwards ray tracing.