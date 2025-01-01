@testset "contructor" begin
    basic_ray = BasicRay([1,2,3.], [1,2,3.])
    @test StepRecorder(basic_ray) isa StepRecorder{3, Float64, BasicRay{3, Float64}}
    @test StepRecorder(basic_ray) == StepRecorder{3, Float64, BasicRay{3, Float64}}(basic_ray)
    @test StepRecorder(basic_ray).ray === basic_ray
end

@testset "advance!" begin
    basic_ray = BasicRay([0,0.], [1,0.])
    ray = StepRecorder(basic_ray)

    @test ray.steps == Point2d[(0, 0)]

    advance!(ray, 0.7)
    @test ray.steps == Point2d[(0, 0), (0.7, 0)]

    ray.ray.dir .= [1,1.]
    advance!(ray, 1.5)
    @test ray.steps == Point2d[(0, 0), (0.7, 0), (2.2, 1.5)]

    ray.ray.dir .= [0.6,-1.7]
    advance!(ray, 1)
    @test ray.steps ≈ Point2d[(0, 0), (0.7, 0), (2.2, 1.5), (2.8, -0.2)]
end