@testset "constructors" begin

    @test BasicRay([1,2,3.], [1,2,3]) == BasicRay(SVector(1,2,3.), SVector(1.,2,3))
    @test BasicRay([1,2,3.], [1,2,3]) == BasicRay{3, Float64}([1,2,3.], [1,2,3])

    @test_throws AssertionError BasicRay([1, 2, 3.], [0, 0, 0.])
    @test_throws DimensionMismatch BasicRay([1, 2.], [1, 2, 3.])

    @test begin
        pos = MVector(1, 2, 3.0)
        dir = MVector(1, 2, 3.0)
        ray = BasicRay(pos, dir)
        pos[1] = 0
        dir[1] = -1
        position(ray) != pos && direction(ray) != dir
    end
end

@testset "advance!" begin
    @test let ray = BasicRay([1, 2.], [1, 0.])
        advance!(ray, 3)
        position(ray) == [4, 2]
    end

    @test let ray = BasicRay([0, 0, 0.], [1, 1, 0.5])
        advance!(ray, √2.25)
        position(ray) ≈ [1, 1, 0.5]
    end
end

@testset "reflect!" begin
    ray = BasicRay([0,0,0.], [1,0,0.])

    reflect!(ray, [1,0,0.])
    @test direction(ray) == [-1,0,0]

    reflect!(ray, normalize([1, 0.5, 0]))
    @test direction(ray) ≈ [0.6, 0.8, 0]

    reflect!(ray, normalize([0.6, 1.1, 1.8]))
    @test direction(ray) ≈ [0.29, 0.23, -0.93] atol=0.1
end