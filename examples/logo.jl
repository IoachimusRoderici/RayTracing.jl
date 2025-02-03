using RayTracing, GeometryBasics, CairoMakie, ColorTypes

function make_logo()
    # "Julia dots", defined in https://github.com/JuliaLang/julia-logo-graphics:
    rotate(point, θ) = [cos(θ) -sin(θ); sin(θ) cos(θ)] * point

    radius = 3/4
    top_center = Point2d(0, 1)
    centers = Point2d[top_center, rotate(top_center, 2/3 * pi), rotate(top_center, -2/3 * pi)]
    offset = Vec2d(0, -1/4)
    centers = [center + offset for center in centers]
    julia_dots = BallPit(radius, centers)

    surface_data = [(SpecularReflection(), nothing) for _ in centers]
    scene = GeometryWithData(julia_dots, surface_data)
    
    # A ray:
    origin = Point2d(-1.5,0.45)
    dir = Vec2d(1,-0.2)
    ray = StepRecorder(BasicRay(origin, dir))
    trace!(ray, scene)
    advance!(ray, 0.4)
    
    # Create the plot:
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
        
    julia_dots_colors = [RGB(.22, .596, .149), RGB(.584, .345, .698), RGB(.796, .235, .2)]
    julia_blue = RGB(.255, .388, .847)
    lines!(ray, color=julia_blue, linewidth=10, joinstyle=:bevel)
    plot!(ax, julia_dots, color=julia_dots_colors)

    return fig
end

logo = make_logo()
save(joinpath(@__DIR__, "logo.png"), logo)
save(joinpath(@__DIR__, "logo.svg"), logo)
