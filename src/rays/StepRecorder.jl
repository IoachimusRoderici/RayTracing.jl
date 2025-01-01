export StepRecorder

"""
Wrapper around a ray type, `R`, that records the trajectory of the ray.

A new point is added to the trajectory after every call to `advance!`.
"""
struct StepRecorder{ND, T, R <: AbstractRay{ND, T}} <: AbstractRay{ND, T}
    ray :: R
    steps :: Vector{Point{ND, T}}

    StepRecorder{ND, T, R}(ray :: R) where {ND, T, R} = new{ND, T, R}(ray, Point{ND, T}[position(ray)])
end

StepRecorder(ray) = StepRecorder{ndims(ray), eltype(ray), typeof(ray)}(ray)

position(ray::StepRecorder) = position(ray.ray)
direction(ray::StepRecorder) = direction(ray.ray)
reflect!(ray::StepRecorder, normal) = reflect!(ray.ray, normal)

function advance!(ray::StepRecorder, distance)
    advance!(ray.ray, distance)
    push!(ray.steps, position(ray))
end