export StateRecorder, StepRecorder

"""
    StateRecorder{ND, T, State, StateFunc <: Function, R <: AbstractRay{ND, T}} <: AbstractRayWithData{ND, T, State}

Wrapper around a ray type, `R`, that records the state of the ray after each
[`advance!`](@ref) call.

The state of the ray is a value of type `State` returned from a function of type
`StateFunc` that takes the ray as argument.
"""
struct StateRecorder{ND, T, State, StateFunc <: Function, R <: AbstractRay{ND, T}} <: AbstractRayWithData{ND, T, State}
    ray :: RayWithData{ND, T, Vector{State}, R}
    get_state :: StateFunc

    function StateRecorder{ND, T, State, StateFunc, R}(ray::R, state_func::StateFunc) where {ND, T, State, StateFunc, R}
        new{ND, T, State, StateFunc, R}(RayWithData(ray, State[state_func(ray)]), state_func)
    end
end

"""
    StateRecorder(ray, state_func=deepcopy, state_type=typeof(ray))

Construct a `StateRecorder` with the appropriate type parameters.

`state_func` must return values of `state_type`, which are the values to be
recorded.

See also [`StepRecorder`](@ref).
"""
StateRecorder(ray, state_type=typeof(ray), state_func=deepcopy) = StateRecorder{ndims(ray), eltype(ray), state_type, typeof(state_func), typeof(ray)}(ray, state_func)

position(ray::StateRecorder) = position(ray.ray)
direction(ray::StateRecorder) = direction(ray.ray)

data(ray::StateRecorder) = data(ray.ray)

function advance!(ray::StateRecorder, distance)
    advance!(ray.ray, distance)
    push!(data(ray.ray), ray.get_state(ray.ray.ray))
end

"""
    StepRecorder{ND, T, R <: AbstractRay{ND, T}}

Wrapper around a ray type, `R`, that records the trajectory of the ray.

A new point is added to the trajectory after every call to [`advance!`](@ref).
The trajectory can be retrieved by [`data`](@ref).
"""
StepRecorder{ND, T, R} = StateRecorder{ND, T, Point{ND, T}, typeof(position), R}
StepRecorder(ray) = StepRecorder{ndims(ray), eltype(ray), typeof(ray)}(ray, position)