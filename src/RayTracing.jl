module RayTracing

using StaticArrays
import LinearAlgebra: norm, normalize, normalize!, ⋅
import GeometryBasics: Point


include("rays/AbstractRay.jl")
include("rays/BasicRay.jl")
include("rays/RayWithData.jl")
include("rays/StateRecorder.jl")

include("reflection_modes/ReflectionMode.jl")
include("reflection_modes/SpecularReflection.jl")

include("scenes/AbstractScene.jl")
include("scenes/BallPit.jl")
include("scenes/GeometryWithData.jl")

include("trace!.jl")

end