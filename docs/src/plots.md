# Plots With Makie.jl

```@meta
CurrentModule = MakieExtension
```

This package has a plotting extension that is activated when [Makie.jl](https://makie.org/website/) is loaded.

The extension adds some recipes to make it easier to plot some ray and scene types.

## BallPit

[`BallPit`](@ref) scenes can be drawn with a scatter plot.
The [`ballpitplot`](@ref) recipe is just a [`scatter`](https://docs.makie.org/stable/reference/plots/scatter)
with circular markers of the correct size.

The name `ballpitplot` is not exported, but there is an overload for `Makie.plottype` so that
`ballpitplot` is always called when plotting `BallPit`s.

```@docs
ballpitplot
```
TODO: add example

## StepRecorder

Argument conversion is setup from [`StepRecorder`](@ref) rays to `PointBased` plots so that
`lines`, `scatter`, etc. can be used.

TODO: add example