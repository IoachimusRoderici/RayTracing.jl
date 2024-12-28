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