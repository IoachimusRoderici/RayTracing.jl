"""
    abstract type AbstractScene end

A scene is a set of surfaces that rays bounce on.
"""
abstract type AbstractScene end

"""
    intersection_distance(ray, scene)

Return the distance from `position(ray)` to the first point of intersection
between between the ray and a surface on the scene, or infinity if there is
no intersection.
"""
function intersection_distance(ray, scene) end