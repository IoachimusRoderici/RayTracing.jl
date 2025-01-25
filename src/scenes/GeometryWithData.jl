"""
    struct GeometryWithData{GeometryType <: SceneGeometry, MappingType} <: AbstractScene

A scene that wraps a [`SceneGeometry`](@ref) and adds a mapping from surface id
to material data.
"""
struct GeometryWithData{GeometryType <: SceneGeometry, MappingType} <: AbstractScene
    geometry :: GeometryType
    data :: MappingType
end

GeometryWithData(geometry, data) = GeometryWithData{typeof(geometry), typeof(data)}(geometry, data)

next_intersection(ray, scene::GeometryWithData) = next_intersection(ray, scene.geometry)

function get_surface_data(scene::GeometryWithData, surface_id, pos)
    geometric_data = get_surface_data(scene.geometry, surface_id, pos)
    reflection_mode, material_data = scene.data[surface_id]

    return reflection_mode, (geometric_data, material_data)
end