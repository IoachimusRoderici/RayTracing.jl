export Sphere

"""
Represents the surface of an ND-dimensional sphere.
"""
struct Sphere{ND, T} <: AbstractSurface{ND}
    center::Point{ND, T}
    radius::T
end

normal(sphere::Sphere, point) = normalize(point - sphere.center)