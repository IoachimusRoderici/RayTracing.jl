using Documenter
using RayTracing, Makie

MakieExtension = Base.get_extension(RayTracing, :MakieExtension)

ray_pages = ["rays/AbstractRay.jl", "rays/BasicRay.jl", "rays/StepRecorder.jl"]
scene_pages = ["scenes/AbstractScene.jl", "scenes/BallPit.jl"]

makedocs(
    sitename = "RayTracing.jl",
    modules = [RayTracing, MakieExtension],
    checkdocs = :exports,
    warnonly = true,
    pages = [
        "Home" => "index.md",
        "rays.md",
        "scenes.md",
        "api_reference.md",
        "plots.md"
    ]
)

deploydocs(
    repo = "github.com/IoachimusRoderici/RayTracing.jl.git",
)
