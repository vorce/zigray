const std = @import("std");
const stdout = std.io.getStdOut().writer();
const print = std.debug.print;

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

    try stdout.print("P3\n{d} {d}\n255\n", .{image_width, image_height});
    
    var j: i32 = image_height - 1;
    while (j >= 0) : (j -= 1) {
      print("Scanlines remaining: {d}\n", .{j});

      var i: i32 = 0;
      while (i < image_width) : (i += 1) {

        var r: f64 = @intToFloat(f64, i) / @intToFloat(f64, (image_width - 1));
        var g:f64 = @intToFloat(f64, j) / @intToFloat(f64, (image_height - 1));
        const b: f64 = 0.25;

        var ir: u32 =  @floatToInt(u32, 255.999 * r);
        var ig: u32 = @floatToInt(u32, 255.999 * g);
        var ib: u32 = @floatToInt(u32, 255.999 * b);

        try stdout.print("{d} {d} {d}\n", .{ir, ig, ib});
      }
    }
    print("\nDone.\n", .{});
}