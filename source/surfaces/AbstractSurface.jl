export AbstractSurface

"""
Represents an ND-dimensional surface that rays can bounce on.
"""
abstract type AbstractSurface{ND} end

"""
    normal(surface, point)

Return the outward normal vector to the surface at the given point,
assuming the point in contained in the surface.
"""
function normal end