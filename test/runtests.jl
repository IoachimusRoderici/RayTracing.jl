using Test, StaticArrays, RayTracing

@testset "RayTracing" begin
    @testset "rays" begin
        include("rays/BasicRay.jl")
    end

    @testset "intersections" begin
        include("intersections/sphere-intersection.jl")
    end
end