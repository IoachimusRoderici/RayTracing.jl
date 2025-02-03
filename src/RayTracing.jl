module RayTracing

using StaticArrays
import LinearAlgebra: norm, normalize, normalize!, ⋅, ×
import GeometryBasics: Point, Vec, Vec3d


include("rays/AbstractRay.jl")
include("rays/BasicRay.jl")
include("rays/RayWithData.jl")
include("rays/StateRecorder.jl")

include("reflection_modes/ReflectionMode.jl")
include("reflection_modes/SpecularReflection.jl")
include("reflection_modes/SetMaterialData.jl")
include("reflection_modes/CombinedReflectionModes.jl")

include("scenes/AbstractScene.jl")
include("scenes/BallPit.jl")
include("scenes/GeometryWithData.jl")

include("trace!.jl")

include("ray_sources/BackwardCameraRays.jl")

end