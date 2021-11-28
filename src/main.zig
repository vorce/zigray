const std = @import("std");
const stderr = std.debug;
const stdout = std.io.getStdOut().writer();
const vector = @import("vector.zig");
const Vec3 = vector.Vec3;

pub fn main() anyerror!void {
    const image_width: u32 = 256;
    const image_height: u32 = 256;

    try stdout.print("P3\n{d} {d}\n255\n", .{ image_width, image_height });

    var y: i32 = image_height - 1;
    while (y >= 0) : (y -= 1) {
        stderr.print("Scanlines remaining: {d}\n", .{y});

        var x: i32 = 0;
        while (x < image_width) : (x += 1) {
            var pixel_color: Vec3 = Vec3.init(@intToFloat(f32, x) / @intToFloat(f32, (image_width - 1)), @intToFloat(f32, y) / @intToFloat(f32, (image_height - 1)), 0.25);
            try Vec3.writeColor(pixel_color);
        }
    }
    stderr.print("\nDone.\n", .{});
}
