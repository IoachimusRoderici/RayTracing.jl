module RayTracing

using StaticArrays
import LinearAlgebra: normalize, ⋅
import GeometryBasics: Point, HyperSphere, origin, radius


include("rays/AbstractRay.jl")
include("rays/BasicRay.jl")

include("surfaces/AbstractSurface.jl")

include("intersections/intersections.jl")
include("intersections/Sphere_intersections.jl")

end