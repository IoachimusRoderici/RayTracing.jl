using RayTracing, GeometryBasics, ColorTypes, Images

# "Julia dots", defined in https://github.com/JuliaLang/julia-logo-graphics:
rotate(point, θ) = [cos(θ) -sin(θ) 0; sin(θ) cos(θ) 0; 0 0 1] * point

half_with = 7/4
radius = 3/4
top_center = Point3d(0, 1, 0)
offset = Vec3d(0, -1/4, 0)
centers = Point3d[top_center, rotate(top_center, 2/3 * pi), rotate(top_center, -2/3 * pi)]
centers = [center + offset for center in centers]
julia_dots_colors = [RGB(.22, .596, .149), RGB(.584, .345, .698), RGB(.796, .235, .2)]

# A scene with the Julia dots as spheres:
julia_dots = BallPit(radius, centers)
reflection_mode = CombinedReflectionModes(SpecularReflection(), SetMaterialData())
surface_data = [(reflection_mode, color) for color in julia_dots_colors]
scene = GeometryWithData(julia_dots, surface_data)

# Single-step backward ray trace:
pixels = 500
camera_distance = 20

rays = BackwardCameraRays{Float64}(
    origin = Point3d(0, 0, camera_distance),
    target = zero(Point3d),
    up = Vec3d(0, 1, 0),
    horizontal_aperture = 2*atan(half_with/camera_distance),
    size = (pixels, pixels)
)

image = similar(rays, RGB24)
backgroundcolor = RGB24(0, 0, 0)

for (i, ray) in pairs(rays)
    ray_with_color = RayWithMutableData(ray, backgroundcolor)
    trace!(ray_with_color, scene, max_steps=1)
    image[i] = data(ray_with_color)
end

save("spheres_on_plain_background.jpg", image)