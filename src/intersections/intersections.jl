export intersection_distance, intersection

"""
    intersection_distance(ray, surface)

Return the distance from `position(ray)` to the first point of intersection
between `surface` and `ray`, or infinity if there is no intersection.
"""
function intersection_distance end

"""
    intersection(ray, surface)

Return the first point of intersection between `surface` and `ray`,
or `nothing` if there is no intersection.
"""
function intersection end

function intersection(ray, surface)
    d = intersection_distance(ray, surface)

    if d < Inf
        return position(ray) + d * direction(ray)
    else
        return nothing
    end
end
