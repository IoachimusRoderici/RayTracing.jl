export MaterialDataOperation

"""
    MaterialDataOperation <: ReflectionMode

A [`ReflectionMode`](@ref) that applies some arbitrary operation between the
ray's data and the material data passed to [`reflect!`](@ref).

The result of the operation is set as the ray's data with [`data!`](@ref) (see
[`RayWithMutableData`](@ref)).

## Example
```jldoctest
julia> ray = RayWithMutableData([0,0,0.], [1,1,1.], 5);

julia> data(ray)
5

julia> reflect!(ray, MaterialDataOperation(+), 0, 10);

julia> data(ray)
15
```
"""
struct MaterialDataOperation{Op} <: ReflectionMode
    operation :: Op
end

function reflect!(ray, mode::MaterialDataOperation, geometric_data, material_data)
    result = mode.operation(data(ray), material_data)
    data!(ray, result)
end