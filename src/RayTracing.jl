module RayTracing

using StaticArrays
import LinearAlgebra: norm, normalize, ⋅
import GeometryBasics: Point, HyperSphere, origin, radius


include("rays/AbstractRay.jl")
include("rays/BasicRay.jl")

include("surfaces/AbstractSurface.jl")

include("scenes/AbstractScene.jl")
include("scenes/BallPit.jl")

include("intersections/intersections.jl")
include("intersections/sphere_intersection.jl")

end