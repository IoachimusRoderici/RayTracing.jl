export trace!, step!

"""
    trace!(ray, scene; kwargs...)

Trace a ray on a scene.

The ray is evolved by [`step!`](@ref)ing until there are no more intersections, or an
ending condition is met.

Ending conditions are specified by keyword arguments. The default values are
such that tracing only stops when there are no more intersections.

The return value is a `Symbol` indicating why tracing stopped. Possible values
are:
- `:max_steps`: The number of steps reached the value of the `max_steps` keyword
  argument.
- `:ray_end_condition`: The function passed to the keyword argument
  `ray_end_condition` evaluated to `true`.
- Any Symbol other that `:ok` returned by [`step!`](@ref).

# Keyword Arguments

- `max_steps`: Stop tracing after this number of steps. Defaults to `Inf`.
- `ray_end_condition`: A function that takes a ray and returns a boolean. Stop
  tracing when the return value is `true`. Defaults to `Returns(false)`.
"""
function trace!(ray, scene;
    max_steps = Inf,
    ray_end_condition = Returns(false)
)
    steps = 0
    while true
        steps >= max_steps     && return :max_steps
        ray_end_condition(ray) && return :ray_end_condition

        step_result = step!(ray, scene)

        step_result != :ok && return step_result
        
        steps += 1
    end
end

"""
    step!(ray, scene)

Advance `ray` on `scene` by one step.

This involves finding the next intersection, advancing, and reflecting.

Return `:ok` if the step was completed, `:no_intersection` if there are no
intersections, or any other Symbol if the step cannot be completed for other
reasons.
"""
function step!(ray, scene)
    distance, surface_id = next_intersection(ray, scene)

    if isinf(distance)
        return :no_intersection
    else
        advance!(ray, distance)
        surface_data = get_surface_data(scene, surface_id, position(ray))
        reflect!(ray, surface_data...)
        return :ok
    end
end
