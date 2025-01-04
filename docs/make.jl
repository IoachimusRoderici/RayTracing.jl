using Documenter
using RayTracing

makedocs(
    sitename = "RayTracing.jl",
    #format = Documenter.HTML(),
    modules = [RayTracing],
    checkdocs = :exports,
    warnonly = :missing_docs
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
