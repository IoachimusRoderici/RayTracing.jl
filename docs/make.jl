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

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
