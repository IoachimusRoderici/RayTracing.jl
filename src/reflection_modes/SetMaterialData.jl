export SetMaterialData

"""
    SetMaterialData <: ReflectionMode

A [`ReflectionMode`](@ref) that sets the ray's data to the material data passed
to [`reflect!`](@ref).

This reflection mode should be used with [`RayWithMutableData`](@ref) or other
ray type implementing a [`data!`](@ref) method.

## Example
```jldoctest
julia> ray = RayWithMutableData([0,0,0.], [1,1,1.], 5);

julia> data(ray)
5

julia> reflect!(ray, SetMaterialData(), 0, 10);

julia> data(ray)
10
```
"""
struct SetMaterialData <: ReflectionMode end

reflect!(ray, mode::SetMaterialData, geometric_data, material_data) = data!(ray, material_data)