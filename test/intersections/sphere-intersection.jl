@testset "intersection_distance(sphere::Sphere, ray)" begin
    ray_x_axis = BasicRay([0, 0, 0.], [1, 0, 0])
    ray_diagonal = BasicRay([0, 0, 0.], [1, 1, 1])
    sphere_x_axis = Sphere{Float64}([5, 0, 0], 3)
    sphere_diagonal = Sphere{Float64}([1, 1, 1], 1.5)
    sphere_uncentered = Sphere{Float64}([2, 2, 1.5], 1)
    sphere_no_intersection = Sphere{Float64}([10, 10, 0], 1)
    sphere_negative_side = Sphere{Float64}([-1, -1, 0], 0.5)

    @test intersection_distance(ray_x_axis, sphere_x_axis) == 2
    @test intersection_distance(ray_x_axis, sphere_diagonal) < 1
    @test intersection_distance(ray_x_axis, sphere_uncentered) == Inf
    @test intersection_distance(ray_x_axis, sphere_no_intersection) == Inf
    @test intersection_distance(ray_x_axis, sphere_negative_side) == Inf

    @test intersection_distance(ray_diagonal, sphere_x_axis) == Inf
    @test intersection_distance(ray_diagonal, sphere_diagonal) ≈ √3 - 1.5
    @test intersection_distance(ray_diagonal, sphere_uncentered) != Inf
    @test intersection_distance(ray_diagonal, sphere_no_intersection) == Inf
    @test intersection_distance(ray_diagonal, sphere_negative_side) == Inf
end

@testset "intersection_distance(sphere::Circle, ray)" begin
    ray1 = BasicRay([1, 0.], [0, -1.])
    ray2 = BasicRay([-1.5, -2.3], [1, 0.3])
    circle1 = Circle{Float64}([1, -2.], 1)
    circle2 = Circle{Float64}([0, 1.], 0.5)

    @test intersection_distance(ray1, circle1) == 1
    @test intersection_distance(ray1, circle2) == Inf
    @test intersection_distance(ray2, circle1) ≈ 1.57842857
    @test intersection_distance(ray2, circle2) == Inf
end
