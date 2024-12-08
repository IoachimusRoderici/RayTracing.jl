export intersection_distance, intersection

"""
    intersection_distance(surface, ray)

Return the distance from `position(ray)` to the first point of intersection
between `surface` and `ray`, or infinity if there is no intersection.
"""
function intersection_distance end

"""
    intersection(surface, ray)

Return the first point of intersection between `surface` and `ray`,
or `nothing` if there is no intersection.
"""
function intersection end

function intersection(surface, ray)
    d = intersection_distance(surface, ray)

    if d < Inf
        return position(ray) + d * direction(ray)
    else
        return nothing
    end
end
