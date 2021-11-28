const std = @import("std");
const stdout = std.io.getStdOut().writer();
const stderr = std.debug;

// pub fn main() anyerror!void {
//     std.log.info("All your codebase are belong to us.", .{});
// }

// test "basic test" {
//     try std.testing.expectEqual(10, 3 + 7);
// }

pub fn floatDiv(val: u32) f64 {
    // const index: u32 = 64;
    const width: u32 = 128;
    return @intToFloat(f64, val) / @intToFloat(f64, width);
}

test "floatDiv" {
    try std.testing.expectEqual(@as(f64, 0.5), floatDiv(64));
}

pub fn main() anyerror!void {
    const image_width: u32 = 256;
    const image_height: u32 = 256;

    try stdout.print("P3\n{d} {d}\n255\n", .{ image_width, image_height });

    var y: i32 = image_height - 1;
    while (y >= 0) : (y -= 1) {
        stderr.print("Scanlines remaining: {d}\n", .{y});

        var x: i32 = 0;
        while (x < image_width) : (x += 1) {
            var r: f64 = @intToFloat(f64, x) / @intToFloat(f64, (image_width - 1));
            var g: f64 = @intToFloat(f64, y) / @intToFloat(f64, (image_height - 1));
            const b: f64 = 0.25;

            var ir: u32 = @floatToInt(u32, 255.999 * r);
            var ig: u32 = @floatToInt(u32, 255.999 * g);
            var ib: u32 = @floatToInt(u32, 255.999 * b);

            try stdout.print("{d} {d} {d}\n", .{ ir, ig, ib });
        }
    }
    stderr.print("\nDone.\n", .{});
}
