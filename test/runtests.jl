using Test, StaticArrays, GeometryBasics, RayTracing
import RayTracing: direction
using LinearAlgebra: normalize, norm

# Equality comparison for rays of the same type:
Base. ==(x::T, y::T) where T <: AbstractRay = all(getfield(x, field) == getfield(y, field) for field in fieldnames(T))

@testset "RayTracing" begin
    @testset "rays" begin
        @testset "BasicRay"     begin include("rays/BasicRay.jl") end
        @testset "StepRecorder" begin include("rays/StepRecorder.jl") end
    end

    @testset "scenes" begin
        @testset "BallPit"      begin include("scenes/BallPit.jl") end
    end
end