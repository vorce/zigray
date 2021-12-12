const std = @import("std");
const stderr = std.debug;
const stdout = std.io.getStdOut().writer();
const Vec3 = @import("vector.zig").Vec3;
const Ray = @import("ray.zig").Ray;
const hittable = @import("hittable.zig");
const Sphere = @import("sphere.zig").Sphere;
const Camera = @import("camera.zig").Camera;
const zigray_utils = @import("util.zig");

pub fn main() anyerror!void {
    // Camera
    const aspect_ratio: f32 = 16.0 / 9.0;
    const viewport_height: f32 = 2.0;
    const viewport_width: f32 = aspect_ratio * viewport_height;
    const focal_length: f32 = 1.0;
    var camera: Camera = Camera.init(viewport_height, viewport_width, focal_length);

    const image_width: u32 = 400;
    const image_height: u32 = @floatToInt(u32, @intToFloat(f32, image_width) / aspect_ratio);
    const samples_per_pixel: u32 = 100;
    const max_depth: i32 = 50;

    // World
    var world: hittable.HittableList = hittable.HittableList.init();
    var sphere: Sphere = Sphere.init(Vec3.init(0.0, 0.0, -1.0), 0.5);
    var land: Sphere = Sphere.init(Vec3.init(0, -100.5, -1), 100);
    world.addHittable(&sphere.hittable);
    world.addHittable(&land.hittable);

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
