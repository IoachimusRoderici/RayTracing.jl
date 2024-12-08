@testset "BasicRay" begin

    @testset "constructors" begin
        @test let con_vector = BasicRay([1,2,3.], [1,2,3]), con_svector = BasicRay(SVector(1,2,3.), SVector(1.,2,3))
            position(con_vector) == position(con_svector) && direction(con_vector) == direction(con_svector)
        end
    
        @test let con_params = BasicRay{3, Float64}([1,2,3.], [1,2,3]), sin_params = BasicRay(SVector(1,2,3.), SVector(1.,2,3))
            position(con_params) == position(sin_params) && direction(con_params) == direction(sin_params)
        end
    
        @test_throws ArgumentError BasicRay([1, 2, 3.], [0, 0, 0.])
        @test_throws DimensionMismatch BasicRay([1, 2.], [1, 2, 3.])
    
        @test begin
            pos = MVector(1, 2, 3.0)
            dir = MVector(1, 2, 3.0)
            ray = BasicRay(pos, dir)
            pos[1] = 0
            dir[1] = 0
            position(ray) != pos && direction(ray) != dir
        end
    end

    @testset "advance!" begin
        @test let ray = BasicRay([1, 2, 3.], [1, 0, 0.])
            advance!(ray, 3)
            position(ray) == [4, 2, 3]
        end

        @test let ray = BasicRay([0, 0, 0.], [1, 1, 0.5])
            advance!(ray, √2.25)
            position(ray) ≈ [1, 1, 0.5]
        end
    end
end