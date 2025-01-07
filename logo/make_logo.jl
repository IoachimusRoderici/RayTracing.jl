using CairoMakie, GeometryBasics, ColorTypes, LinearAlgebra, RayTracing
rotate(point, θ) = [cos(θ) -sin(θ); sin(θ) cos(θ)] * point

radius = 0.7
top_center = Point2d(0, 1)
centers = Point2d[top_center, rotate(top_center, 2/3 * pi), rotate(top_center, -2/3 * pi)]
julia_dots = BallPit(radius, centers)
julia_dots_colors = [RGB(.22, .596, .149), RGB(.584, .345, .698), RGB(.796, .235, .2)]

angles = 0:0.06:2pi
dirs = [Vec2d(cos(t), sin(t)) for t in angles];
rays = [StepRecorder(BasicRay(Point2d(0,0), dir)) for dir in dirs];
for ray in rays
    trace!(ray, julia_dots)
    pop!(ray.steps)
    popfirst!(ray.steps)
end
points = vcat((ray.steps for ray in rays)...);

function _color(point)
    for i in eachindex(julia_dots.centers)
        d = norm(point-julia_dots.centers[i])
        if d ≈ radius
            return julia_dots_colors[i]
        end
    end
end
colors = _color.(points);


#Base.abs(p::Point) = abs.(p)
fig = Figure(
    figure_padding = 0,
    backgroundcolor = :transparent
)
ax = Axis(fig[1,1],
    aspect = DataAspect(),
    limits = (-7/4, 7/4, -7/4, 7/4),
    backgroundcolor = :transparent
)
hidedecorations!(ax)
hidespines!(ax)
autolimits!(ax)
#limit = maximum(maximum.(abs.(points))) + 0.1
#limits!(ax, -limit, limit, -limit, limit)

scatter!(ax, points, markersize=0.06, markerspace=:data, color=colors)

save(joinpath(@__DIR__, "logo.png"), fig)
save(joinpath(@__DIR__, "logo.svg"), fig)