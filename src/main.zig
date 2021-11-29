const std = @import("std");
const stderr = std.debug;
const stdout = std.io.getStdOut().writer();
const Vec3 = @import("vector.zig").Vec3;
const Ray = @import("ray.zig").Ray;

pub fn main() anyerror!void {
    const aspect_ratio: f32 = 16.0 / 9.0;
    const image_width: u32 = 400;
    const image_height: u32 = @floatToInt(u32, @intToFloat(f32, image_width) / aspect_ratio);

    // Camera
    const viewport_height: f32 = 2.0;
    const viewport_width: f32 = aspect_ratio * viewport_height;
    const focal_length: f32 = 1.0;

    const origin: Vec3 = Vec3.init(0.0, 0.0, 0.0);
    const horizontal: Vec3 = Vec3.init(viewport_width, 0.0, 0.0);
    const vertical: Vec3 = Vec3.init(0.0, viewport_height, 0.0);
    const lower_left_corner: Vec3 = origin.sub(horizontal.divideBy(2.0)).sub(vertical.divideBy(2.0)).sub(Vec3.init(0.0, 0.0, focal_length));

    try stdout.print("P3\n{d} {d}\n255\n", .{ image_width, image_height });

    var y: i32 = image_height - 1;
    while (y >= 0) : (y -= 1) {
        stderr.print("Scanlines remaining: {d}\n", .{y});

        var x: i32 = 0;
        while (x < image_width) : (x += 1) {
            var u = @intToFloat(f32, x) / @intToFloat(f32, image_width - 1);
            var v = @intToFloat(f32, y) / @intToFloat(f32, image_height - 1);
            var ray = Ray.init(origin, lower_left_corner.add(horizontal.multiplyBy(u)).add(vertical.multiplyBy(v)).sub(origin));
            var pixel_color = ray.color();

            try Vec3.writeColor(pixel_color);
        }
    }
    stderr.print("\nDone.\n", .{});
}
