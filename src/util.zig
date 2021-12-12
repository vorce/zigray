const std = @import("std");
const RndGen = std.rand.DefaultPrng;
var rnd = RndGen.init(0);

const pi: f32 = 3.1415926535897932384626433;

pub fn randomFloat() f32 {
    return rnd.random().float(f32);
}

test "randomFloat" {
    const expected_result: f32 = 0.285326123;
    try std.testing.expectEqual(expected_result, randomFloat());
}

pub fn randomFloatBounded(min: f32, max: f32) f32 {
    return min + (max - min) * randomFloat();
}

pub fn degreesToRadians(degrees: f32) f32 {
    return degrees * pi / 180;
}

pub fn tan(radians: f32) f32 {
    return (@sin(radians) / @cos(radians));
}
