export trace!
public AbstractScene

"""
    abstract type AbstractScene

A set of surfaces that rays can bounce on.
"""
abstract type AbstractScene end

"""
    trace!(ray, scene)

Trace a ray on a scene.

The ray is evolved by `advance!`ing to each next intersection
with an algorithm defined by each scene type.
"""
function trace! end