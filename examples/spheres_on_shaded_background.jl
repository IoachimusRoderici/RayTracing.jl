using RayTracing, GeometryBasics, LinearAlgebra, ColorTypes, ColorVectorSpace, Images
using RayTracing: direction

# "Julia dots", defined in https://github.com/JuliaLang/julia-logo-graphics:
rotate(point, θ) = [cos(θ) -sin(θ) 0; sin(θ) cos(θ) 0; 0 0 1] * point

radius = 3/4
top_center = Point3d(0, 1, 0)
offset = Vec3d(0, -1/4, 0)
centers = Point3d[top_center, rotate(top_center, 2/3 * pi), rotate(top_center, -2/3 * pi)]
centers = [center + offset for center in centers]
julia_dots_colors = [RGB(.22, .596, .149), RGB(.584, .345, .698), RGB(.796, .235, .2)]

# A scene with the Julia dots as spheres:
julia_dots = BallPit(radius, centers)
reflection_mode = CombinedReflectionModes(SpecularReflection(), MaterialDataOperation(⊙))
surface_data = [(reflection_mode, color) for color in julia_dots_colors]
scene = GeometryWithData(julia_dots, surface_data)

# Gradient background light:
top_color = RGB(0.0, 0.75, 1.0)
bottom_color = RGB(0.722, 0.745, 0.765)
up = Vec3d(0, 1, 0)

function background_color(dir)
    t = dir ⋅ up
    return (bottom_color*(1-t) + top_color*(t+1)) / 2
end

# Backward ray trace:
pixels = 800
camera_pos = Point3d(0.9, -6, 5)

rays = BackwardCameraRays{Float64}(
    origin = camera_pos,
    target = zero(Point3d),
    up = up,
    horizontal_aperture = 0.4,
    size = (pixels, pixels)
)

image = similar(rays, RGB24)

for (i, ray) in pairs(rays)
    ray_with_color = RayWithMutableData(ray, RGB24(1,1,1))
    trace!(ray_with_color, scene)
    image[i] = data(ray_with_color) ⊙ background_color(direction(ray))
end

save("spheres_on_shaded_background.jpg", image)