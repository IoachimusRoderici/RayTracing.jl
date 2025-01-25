module RayTracing

using StaticArrays
import LinearAlgebra: norm, normalize, normalize!, ⋅
import GeometryBasics: Point, HyperSphere, origin, radius


include("rays/AbstractRay.jl")
include("rays/BasicRay.jl")
include("rays/StepRecorder.jl")

include("reflection_modes/ReflectionMode.jl")
include("reflection_modes/SpecularReflection.jl")

include("scenes/AbstractScene.jl")
include("scenes/BallPit.jl")

include("trace!.jl")

end