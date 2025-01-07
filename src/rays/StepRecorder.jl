export StepRecorder

"""
    struct StepRecorder{ND, T, R <: AbstractRay{ND, T}} <: AbstractRay{ND, T}

Wrapper around a ray type, `R`, that records the trajectory of the ray.

`ND` is the number of dimensions and `T` is the type used for numeric calculations.

The trajectory is stored in the field `steps :: Vector{Point{ND, T}}`.
A new point is added to the trajectory after every call to [`advance!`](@ref).
"""
struct StepRecorder{ND, T, R <: AbstractRay{ND, T}} <: AbstractRay{ND, T}
    ray :: R
    steps :: Vector{Point{ND, T}}

    StepRecorder{ND, T, R}(ray :: R) where {ND, T, R} = new{ND, T, R}(ray, Point{ND, T}[position(ray)])
end

"""
    StepRecorder{ND, T, R}(ray :: R) where {ND, T, R}
    StepRecorder(ray)

Construct a `StepRecorder{ND, T, R}` that wraps `ray`.
With the second signature, `ND`, `T` and `R` are determined automatically from the argument.
"""
StepRecorder(ray) = StepRecorder{ndims(ray), eltype(ray), typeof(ray)}(ray)

position(ray::StepRecorder) = position(ray.ray)
direction(ray::StepRecorder) = direction(ray.ray)

function advance!(ray::StepRecorder, distance)
    advance!(ray.ray, distance)
    push!(ray.steps, position(ray))
end