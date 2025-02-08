# RayTracing.jl

This package aims to provide general porpuse tools to create [ray tracing](https://en.wikipedia.org/wiki/Ray_tracing) simulations.

There are two main components to this package:

- [Rays](@ref rays_page): Objects that move in straight lines starting from a given position and direction.
  These can be used to represent light, color, sound, particles, etc.
- [Scenes](@ref scenes_page): Sets of surfaces that rays bounce on or otherwise interact with.

There is also an extension to make [plots with Makie](@ref plots_page).
