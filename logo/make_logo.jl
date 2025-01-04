using RayTracing, GeometryBasics, CairoMakie, ColorTypes

# Create a plot:
fig = Figure(
    size = (600, 600),
    figure_padding = 0,
    backgroundcolor = :transparent
)
ax = Axis(fig[1,1],
    aspect = 1,
    limits = (-7/4, 7/4, -7/4, 7/4),
    backgroundcolor = :transparent
)
hidedecorations!(ax)
hidespines!(ax)

# "Julia dots", defined in https://github.com/JuliaLang/julia-logo-graphics:
rotate(point, θ) = [cos(θ) -sin(θ); sin(θ) cos(θ)] * point

radius = 3/4
top_center = Point2d(0, 1)
centers = Point2d[top_center, rotate(top_center, 2/3 * pi), rotate(top_center, -2/3 * pi)]
offset = Vec2d(0, -1/4)
centers = [center + offset for center in centers]
julia_dots = BallPit(radius, centers)

dot_colors = [RGB(.22, .596, .149), RGB(.584, .345, .698), RGB(.796, .235, .2)]
julia_dots_plot = plot!(ax, julia_dots, color=dot_colors)

# A ray:
origin = Point2d(-1.5,0.45)
dir = Vec2d(1,-0.2)
ray = StepRecorder(BasicRay(origin, dir))
trace!(ray, julia_dots)
advance!(ray, 0.4)

# origin = Observable(Point2d(-1.5R,0.7))
# dir = Observable(Vec2d(1,-0.2))
# ray = @lift StepRecorder(BasicRay($origin, $dir))
# on(ray) do r trace!(r, julia_dots) end

julia_blue = RGB(.255, .388, .847)
ray_plot = lines!(ray, color=julia_blue, linewidth=10, joinstyle=:bevel)

# Save the plot:
save(joinpath(@__DIR__, "logo.svg"), fig)
save(joinpath(@__DIR__, "logo.png"), fig)