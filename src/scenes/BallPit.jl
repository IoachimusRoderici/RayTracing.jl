export BallPit

"""
    struct BallPit{ND, T} <: AbstractScene

A set of same-size spheres in `ND` dimensions with arithmetic type `T`.
"""
struct BallPit{ND, T} <: AbstractScene
    r :: T
    centers :: Vector{Point{ND, T}}
end

"""
    trace!(ray, scene::BallPit; max_steps=1000)

Trace `ray` on the given `BallPit` by `advance!`ing to each next
intersection and `reflect!`ing on the corresponding sphere, until
there are no more intersections or `max_steps` are reached.
"""
function trace!(ray, scene::BallPit; max_steps=1000)
    steps = 0
    distance, index = next_intersection(ray, scene)

    while distance < Inf && steps < max_steps
        advance!(ray, distance)
        steps += 1

        normal = normalize(position(ray) - scene.centers[index])
        reflect!(ray, normal)

        distance, index = next_intersection(ray, scene)
    end

    # if no more intersections, move to limit of scene:
    if index == 0
        max_distance = maximum(norm, scene.centers)
        discriminant = (direction(ray)⋅position(ray))^2 - direction(ray)⋅position(ray) + max_distance^2
        distance = √discriminant - direction(ray)⋅position(ray)
        advance!(ray, distance)
    end
end

"""
    next_intersection(ray, ballpit::BallPit) -> (distance, index)

Return the distance to the next intrsection and the index of the corresponding sphere.

If there is no intersection, return infinity and 0.
"""
function next_intersection(ray, ballpit::BallPit)
    distance_to_proyection, i = findmin(c -> distance_to_proyection_if_intersects(ray, c, ballpit.r), ballpit.centers)
    if distance_to_proyection < Inf
        discriminant = distance_to_proyection^2 - sum(abs2, ballpit.centers[i] - position(ray)) + ballpit.r^2
        distance = distance_to_proyection - √discriminant
        return distance, i
    else
        return distance_to_proyection, 0
    end
end

function distance_to_proyection_if_intersects(ray, center, radius)
    pos_to_center = center - position(ray)
    distance_to_proyection = pos_to_center ⋅ direction(ray)
    if distance_to_proyection > 0
        distance_to_line = norm(pos_to_center - distance_to_proyection*direction(ray))
        if distance_to_line < radius
            return distance_to_proyection
        end
    end
    return typemax(eltype(ray))
end
