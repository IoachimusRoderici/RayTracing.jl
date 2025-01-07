@testset "perfect zig-zag" begin
    n_spheres = 5
    centers = Point2d[(0.5 + i, (-1)^i) for i in 0:n_spheres-1]
    balls = BallPit(0.5, centers)
    ray = StepRecorder(BasicRay([0,0.], [1,1.]))
    trace!(ray, balls)

    @test length(ray.steps) == n_spheres + 2
    @test ray.steps[begin:end-1] ≈ [Point2d[(0,0)]; Point2d[(0.5 + i, 0.5(-1)^i) for i in 0:n_spheres-1]]
end

@testset "single 3d bounce" begin
    start_point = Point3f(4,3,2.)
    dir = Vec3f(-2,-0.8,-1.)
    ray = StepRecorder(BasicRay(start_point, dir))
    balls = BallPit(1f0, Point3f[(1,1,1)])
    trace!(ray, balls)

    @test length(ray.steps) == 3
    @test ray.steps[1] == start_point
    @test ray.steps[2] ≈ Point3f(1.23, 1.89, 0.62) atol=0.01 # Calculated on geogebra
    @test normalize(ray.steps[3] - ray.steps[2]) ≈ Vec3f(-0.68, 0.27, -0.68) atol=0.01 # Calculated on geogebra
end

@testset "infinite 3d bounces" begin
    start_point = Point3d(0.5957713073680874, 0.3104919621005878, 0.7274306274568393) # rand(Point3d)
    dir = Vec3d(0.345799324352982, 0.4730639495326323, 0.8170120981998542)            # rand(Vec3d)
    centers = Point3d[start_point + dir, start_point - dir]
    balls = BallPit(0.5norm(dir), centers)
    ray = StepRecorder(BasicRay(start_point, dir))
    max_steps = 20
    trace!(ray, balls; max_steps)

    expected_intersections = (start_point + 0.5dir, start_point - 0.5dir)
    @test length(ray.steps) == max_steps + 1
    @test all(isapprox.(ray.steps[2:2:end], expected_intersections[1], atol=0.01))
    @test all(isapprox.(ray.steps[3:2:end], expected_intersections[2], atol=0.01))
end