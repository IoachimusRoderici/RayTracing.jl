export RayWithData, RayWithMutableData, data, data!
public AbstractRayWithData

"""
    abstract type AbstractRayWithData{ND, T, Data} <: AbstractRay{ND, T}

A ray that can hold additional data of type `Data`.

See also: [`data`](@ref), [`RayWithData`](@ref), [`RayWithMutableData`](@ref).
"""
abstract type AbstractRayWithData{ND, T, Data} <: AbstractRay{ND, T} end

"""
    RayWithData{ND, T, Data, Ray <: AbstractRay{ND, T}} <: AbstractRayWithData{ND, T, Data}

Wrapper around a ray type, `R`, to hold arbitrary data of type `Data`.

The data can be retrieved with [`data`](@ref). If you want the data to be
mutable, use a mutable `Data` type or use [`RayWithMutableData`](@ref).
"""
struct RayWithData{ND, T, Data, Ray <: AbstractRay{ND, T}} <: AbstractRayWithData{ND, T, Data}
    ray :: Ray
    data :: Data
end

"""
    RayWithMutableData{ND, T, Data, Ray <: AbstractRay{ND, T}} <: AbstractRayWithData{ND, T, Data}

Wrapper around a ray type, `R`, to hold arbitrary mutable data of type `Data`.

The data can be retrieved with [`data`](@ref) and assigned to with
[`data!`](@ref). If you don't need to assign to the data field, use
[`RayWithData`](@ref) instead.
"""
mutable struct RayWithMutableData{ND, T, Data, Ray <: AbstractRay{ND, T}} <: AbstractRayWithData{ND, T, Data}
    const ray :: Ray
    data :: Data
end

"""
    RayWithData(ray, data)
    RayWithData(pos, dir, data)

Construct a RayWithData with the given `data` and `ray`, or with the given
`data` and a [`BasicRay`](@ref) constructed from `pos` and `dir`.
"""
RayWithData(ray, data) = RayWithData{ndims(ray), eltype(ray), typeof(ray), typeof(data)}(ray, data)
RayWithData(pos, dir, data) = RayWithData(BasicRay(pos, dir), data)

"""
    RayWithMutableData(ray, data)
    RayWithMutableData(pos, dir, data)

Construct a RayWithMutableData with the given `data` and `ray`, or with the
given `data` and a [`BasicRay`](@ref) constructed from `pos` and `dir`.
"""
RayWithMutableData(ray, data) = RayWithMutableData{ndims(ray), eltype(ray), typeof(ray), typeof(data)}(ray, data)
RayWithMutableData(pos, dir, data) = RayWithMutableData(BasicRay(pos, dir), data)

position(ray::AbstractRayWithData) = position(ray.ray)
direction(ray::AbstractRayWithData) = direction(ray.ray)

"""
    data(ray::AbstractRayWithData)

Return the data carried by `ray`.
"""
data(ray::RayWithData) = ray.data
data(ray::RayWithMutableData) = ray.data

"""
    data!(ray::RayWithMutableData, data)

Set the data carried by `ray`.
"""
data!(ray::RayWithMutableData, data) = ray.data=data