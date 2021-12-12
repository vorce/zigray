const std = @import("std");
const stderr = std.debug;
const stdout = std.io.getStdOut().writer();
const Vec3 = @import("vector.zig").Vec3;
const Ray = @import("ray.zig").Ray;
const hittable = @import("hittable.zig");
const Sphere = @import("sphere.zig").Sphere;
const Camera = @import("camera.zig").Camera;
const zigray_utils = @import("util.zig");
const material = @import("material.zig");

pub fn main() anyerror!void {
    // Camera
    const aspect_ratio: f32 = 16.0 / 9.0;
    var camera: Camera = Camera.init(Vec3.init(-2, 2, 1), Vec3.init(0, 0, -1), Vec3.init(0, 1, 0), 90, aspect_ratio);

    const image_width: u32 = 400;
    const image_height: u32 = @floatToInt(u32, @intToFloat(f32, image_width) / aspect_ratio);
    const samples_per_pixel: u32 = 100;
    const max_depth: i32 = 50;

    // World
    // Is there a need for variable materials and shapes? maybe const makes more sense if not.
    var world: hittable.HittableList = hittable.HittableList.init();
    var material_ground = material.Lambertian.init(Vec3.init(0.8, 0.8, 0.0));
    var material_center = material.Lambertian.init(Vec3.init(0.7, 0.3, 0.3));
    var material_left = material.Mirror.init(Vec3.init(0.8, 0.8, 0.8));
    var material_right = material.Metal.init(Vec3.init(0.8, 0.6, 0.2), 0.8);

    var land: Sphere = Sphere.init(Vec3.init(0, -100.5, -1), 100, &material_ground.scatterable);
    var sphere_center: Sphere = Sphere.init(Vec3.init(0.0, 0.0, -1.0), 0.5, &material_center.scatterable);
    var sphere_left: Sphere = Sphere.init(Vec3.init(-1.0, 0.0, -1.0), 0.5, &material_left.scatterable);
    var sphere_right: Sphere = Sphere.init(Vec3.init(1.0, 0.0, -1.0), 0.5, &material_right.scatterable);

    world.addHittable(&land.hittable);
    world.addHittable(&sphere_center.hittable);
    world.addHittable(&sphere_left.hittable);
    world.addHittable(&sphere_right.hittable);

    try stdout.print("P3\n{d} {d}\n255\n", .{ image_width, image_height });

    var y: i32 = image_height - 1;
    while (y >= 0) : (y -= 1) {
        stderr.print("Scanlines remaining: {d}\n", .{y});

        var x: i32 = 0;
        while (x < image_width) : (x += 1) {
            var pixel_color: Vec3 = Vec3.init(0.0, 0.0, 0.0);
            var sample: u32 = 0;
            while (sample < samples_per_pixel) : (sample += 1) {
                var u: f32 = (@intToFloat(f32, x) + zigray_utils.randomFloat()) / @intToFloat(f32, image_width - 1);
                var v: f32 = (@intToFloat(f32, y) + zigray_utils.randomFloat()) / @intToFloat(f32, image_height - 1);
                var ray: Ray = camera.getRay(u, v);
                pixel_color = pixel_color.add(ray.color(&world.hittable, max_depth));
            }
            try Vec3.writeColor(pixel_color, samples_per_pixel);
        }
    }
    stderr.print("\nDone.\n", .{});
}
