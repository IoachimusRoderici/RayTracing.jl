export AbstractSurface

"""
Represents an `ND`-dimensional surface that rays can bounce on.
"""
abstract type AbstractSurface{ND} end

"""
    normal(surface, point)

Return a vector normal to `surface` at `point`, assuming `point`
is contained in the surface.

For closed surfaces, return the outward-pointing normal vector.
"""
function normal end

normal(sphere::HyperSphere, point) = normalize(point - origin(sphere))