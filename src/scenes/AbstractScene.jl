public AbstractScene, SceneGeometry, next_intersection, get_surface_data

"""
    abstract type AbstractScene

A set of objects that rays can bounce on.

Includes information about the geometry of the objects and also about surface
properties.

See also: [`SceneGeometry`](@ref).
"""
abstract type AbstractScene end

"""
    abstract type SceneGeometry

A geometric description of a set of objects.

Similar to [`AbstractScene`](@ref), but only contains geometric information.
Scenes can be created by adding surface information to existing scene
geometries.
"""
abstract type SceneGeometry end

"""
    next_intersection(ray, scene::AbstractScene) -> distance, surface_id
    next_intersection(ray, scene::SceneGeometry) -> distance, surface_id

Calculate the next intersection between `ray` and any object from `scene`.

Return the distance to the intersection and an id of the corresponding surface.
The type and meaning of the id is defined by the conrete type of `scene`.

If there are no intersections, the returned distance is infinity and the surface
id is unspecified.
"""
function next_intersection end

"""
    get_surface_data(scene::AbstractScene, surface_id, pos) -> reflection_mode, geometric_data, material_data
    get_surface_data(scene::SceneGeometry, surface_id, pos) -> geometric_data

Return surface data for a surface of `scene` identified by `surface_id` (as
returned by [`next_intersection`](@ref)) at point `pos`.

Scene geometries only return data about the geometry of the surface.
`AbstractScene`s return data about geometry as well as material properties and
reflection mode.
"""
function get_surface_data end