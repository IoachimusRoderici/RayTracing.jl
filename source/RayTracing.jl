module RayTracing

using StaticArrays
import LinearAlgebra: normalize
import GeometryBasics: Point


include("rays/AbstractRay.jl")
include("rays/BasicRay.jl")

include("surfaces/AbstractSurface.jl")
include("surfaces/Sphere.jl")

end