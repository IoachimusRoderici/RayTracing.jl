@testset "sphere-intersection" begin
    using GeometryBasics: Sphere, Circle

    @testset "intersection_distance(sphere::Sphere, ray)" begin
        ray_x_axis = BasicRay([0, 0, 0.], [1, 0, 0])
        ray_diagonal = BasicRay([0, 0, 0.], [1, 1, 1])
        sphere_x_axis = Sphere{Float64}([5, 0, 0], 3)
        sphere_diagonal = Sphere{Float64}([1, 1, 1], 1.5)
        sphere_uncentered = Sphere{Float64}([2, 2, 1.5], 1)
        sphere_no_intersection = Sphere{Float64}([10, 10, 0], 1)
        sphere_negative_side = Sphere{Float64}([-1, -1, 0], 0.5)

        @test intersection_distance(sphere_x_axis, ray_x_axis) == 2
        @test intersection_distance(sphere_diagonal, ray_x_axis) < 1
        @test intersection_distance(sphere_uncentered, ray_x_axis) == Inf
        @test intersection_distance(sphere_no_intersection, ray_x_axis) == Inf
        @test intersection_distance(sphere_negative_side, ray_x_axis) == Inf

        @test intersection_distance(sphere_x_axis, ray_diagonal) == Inf
        @test intersection_distance(sphere_diagonal, ray_diagonal) ≈ √3 - 1.5
        @test intersection_distance(sphere_uncentered, ray_diagonal) != Inf
        @test intersection_distance(sphere_no_intersection, ray_diagonal) == Inf
        @test intersection_distance(sphere_negative_side, ray_diagonal) == Inf
    end

    @testset "intersection_distance(sphere::Circle, ray)" begin
        ray1 = BasicRay([1, 0.], [0, -1.])
        ray2 = BasicRay([-1.5, -2.3], [1, 0.3])
        circle1 = Circle{Float64}([1, -2.], 1)
        circle2 = Circle{Float64}([0, 1.], 0.5)

        @test intersection_distance(circle1, ray1) == 1
        @test intersection_distance(circle2, ray1) == Inf
        @test intersection_distance(circle1, ray2) ≈ 1.57842857
        @test intersection_distance(circle2, ray2) == Inf
    end
end
