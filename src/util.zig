const std = @import("std");
const RndGen = std.rand.DefaultPrng;
var rnd = RndGen.init(0);

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
