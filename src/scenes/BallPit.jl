export BallPit

"""
    struct BallPit{ND, T} <: AbstractScene

A set of same-size spheres in `ND` dimensions with arithmetic type `T`.
"""
struct BallPit{ND, T} <: AbstractScene
    r :: T
    centers :: Vector{Point{ND, T}}
end

function intersection_distance(ballpit::BallPit, ray)
    distance_to_proyection, i = findmin(c -> distance_to_proyection_if_intersects(c, ballpit.r, ray), ballpit.centers)
    if distance_to_proyection < Inf
        discriminant = distance_to_proyection^2 - sum(abs2, ballpit.centers[i] - position(ray)) + ballpit.r^2
        distance = distance_to_proyection - √discriminant
        return distance
    else
        return distance_to_proyection
    end
end

function distance_to_proyection_if_intersects(center, radius, ray)
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
