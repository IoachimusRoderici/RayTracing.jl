export BackwardCameraRays

"""
    BackwardCameraRays{T} <: AbstractMatrix{BasicRay{3, T}}

A rectangular grid of rays starting from a single point.

If used for backward ray tracing, each ray represents a pixel on a camera.

The rays are of type [`BasicRay`](@ref)`{3,T}`, and they are evaluated lazily on
each call to `getindex`.
"""
struct BackwardCameraRays{T <: Real} <: AbstractMatrix{BasicRay{3, T}}
    size :: NTuple{2, UInt}     # (width, height), number of pixels.
    origin :: Point{3, T}       # Initial position of the rays.
    first_pixel :: Point{3, T}  # Position of the top-left pixel relative to origin.
    down_1_pixel :: Vec{3, T}   # Vector going to the next pixel down.
    right_1_pixel :: Vec{3, T}  # Vector going to the next pixel on the right.
end

"""
    BackwardCameraRays{T}(; kwargs...)

Construct `BackwardCameraRays{T}` from keyword arguments describing the camera as
in [Wikipedia: Calculate rays for rectangular viewport](https://en.wikipedia.org/wiki/Ray_tracing_(graphics)#Calculate_rays_for_rectangular_viewport).

Keyword arguments:
- `origin`: The point where the camera is located.
- `dir`: The direction the camera is pointing in. Can't be used together with
  `target`.
- `target`: A point the camera is pointing to. Can't be used together with
  `dir`.
- `up`: The "up" direction of the camera (controls the rotation of the camera,
  can be used together with `roll`). Defaults to `[0, 0, 1]`.
- `roll`: Angle of rotation of the camera around `dir`, measured with respect to
  the `up` direction. Defaults to `0`, meaning no rotation.
- `horizontal_aperture`: The angle of aperture of the horizontal dimension of
  the image (in radians). The angle of aperture for the vertical dimension is
  determined by the aspect ratio given by `image_size`.
- `size`: The size of the image, in pixels. Must be a *(height, width)*
  tuple.
"""
function BackwardCameraRays{T}(;
    origin,
    horizontal_aperture,
    size,
    dir = missing,
    target = missing,
    up = Vec(0., 0., 1.),
    roll = 0.
) where {T}
    # Validate and convert arguments:
    count(ismissing, (dir, target)) != 1 && throw(ArgumentError("Exactly one of `dir` and `target` must be specified."))
    size[2] <= 1 && throw(ArgumentError("The width must be at least 2."))

    # Make an orthonormal base (right, down, forward):
    forward = normalize(Vec3d( ismissing(dir) ? target-origin : dir ))
    up_orthogonal = Vec3d( up - (up ⋅ forward) * forward )
    up_rotated = cos(roll)*up_orthogonal + sin(roll)*(forward×up_orthogonal)
    down = normalize(-up_rotated)
    right = normalize(down × forward)

    # Calculate half-sides of the rectangle (distance to origin is 1):
    half_width = tan(horizontal_aperture/2)
    pixel_aspect_ratio = (size[1] - 1) / (size[2] - 1)
    half_height = half_width * pixel_aspect_ratio

    # Calculate direction for the first pixel:
    first_pixel = forward - half_width*right - half_height*down

    # Calculate offset for other pixels:
    offset_per_pixel = 2half_width / (size[2] - 1)
    down_1_pixel = offset_per_pixel * down
    right_1_pixel = offset_per_pixel * right

    return BackwardCameraRays{T}(size, origin, first_pixel, down_1_pixel, right_1_pixel)
end

Base.size(rays::BackwardCameraRays) = rays.size

function Base.getindex(rays::BackwardCameraRays{T}, I::Vararg{Int, 2}) where T
    dir = rays.first_pixel + I[1]*rays.down_1_pixel + I[2]*rays.right_1_pixel
    return BasicRay{3,T}(rays.origin, dir)
end