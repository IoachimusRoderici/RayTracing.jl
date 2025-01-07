"""
    ballpitplot(scene::BallPit)

Plot a scatter of spheres as defined by the `scene`.

Keyword arguments are passed on to [scatter](https://docs.makie.org/stable/reference/plots/scatter).
"""
@recipe(BallPitPlot, balls) do _
    Attributes()
end

function Makie.plot!(ballplot::BallPitPlot{<:Tuple{BallPit}})
    balls = ballplot.balls[]
    scatter!(ballplot, balls.centers;
        marker = Circle,
        markersize = 2 * balls.r,
        markerspace = :data,
        ballplot.kw...
    )
end

Makie.plottype(balls::BallPit) = BallPitPlot