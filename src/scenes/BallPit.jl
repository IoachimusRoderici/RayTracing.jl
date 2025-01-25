export BallPit

"""
    struct BallPit{ND, T} <: SceneGeometry

A set of same-size spheres in `ND` dimensions with arithmetic type `T`.

The arguments for the constructor are:
- `r::T`, the radius of the spheres.
- `centers::Vector{Point{ND, T}}`, the centers of the spheres.
"""
struct BallPit{ND, T} <: SceneGeometry
    r :: T
    centers :: Vector{Point{ND, T}}
end

function next_intersection(ray, scene::BallPit)
    distance, i = findmin(center -> _distance_to_proyection_if_intersects(ray, center, scene.r), scene.centers)
    
    if !isinf(distance)
        discriminant = distance^2 - sum(abs2, scene.centers[i] - position(ray)) + scene.r^2
        distance -= √discriminant
    end

    return distance, i
end

function _distance_to_proyection_if_intersects(ray, center, radius)
    pos_to_center = center - position(ray)
    distance_to_proyection = pos_to_center ⋅ direction(ray)

    if distance_to_proyection > 0
        distance_from_line = norm(pos_to_center - distance_to_proyection*direction(ray))
        if distance_from_line < radius
            return distance_to_proyection
        end
    end
    return typemax(eltype(ray))
end

get_surface_data(scene::BallPit, id, pos) = normalize(pos - scene.centers[id])
