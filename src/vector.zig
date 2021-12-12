const std = @import("std");
const testing = std.testing;
const stdout = std.io.getStdOut().writer();
const zigray_utils = @import("util.zig");

pub const Vec3 = struct {
    x: f32 = 0.0,
    y: f32 = 0.0,
    z: f32 = 0.0,

    pub fn init(x: f32, y: f32, z: f32) Vec3 {
        return Vec3{
            .x = x,
            .y = y,
            .z = z,
        };
    }

    pub fn add(self: Vec3, other: Vec3) Vec3 {
        return init(self.x + other.x, self.y + other.y, self.z + other.z);
    }

    pub fn sub(self: Vec3, other: Vec3) Vec3 {
        return init(self.x - other.x, self.y - other.y, self.z - other.z);
    }

    pub fn mult(self: Vec3, other: Vec3) Vec3 {
        return init(self.x * other.x, self.y * other.y, self.z * other.z);
    }

    pub fn multiplyBy(self: Vec3, factor: f32) Vec3 {
        return mult(self, init(factor, factor, factor));
    }

    pub fn div(self: Vec3, other: Vec3) Vec3 {
        return init(self.x / other.x, self.y / other.y, self.z / other.z);
    }

    pub fn divideBy(self: Vec3, divisor: f32) Vec3 {
        return div(self, init(divisor, divisor, divisor));
    }

    pub fn lengthSquared(self: Vec3) f32 {
        return (self.x * self.x) + (self.y * self.y) + (self.z * self.z);
    }

    pub fn length(self: Vec3) f32 {
        return @sqrt(lengthSquared(self));
    }

    pub fn dot(self: Vec3, other: Vec3) f32 {
        return self.x * other.x + self.y * other.y + self.z * other.z;
    }

    pub fn cross(self: Vec3, other: Vec3) Vec3 {
        return init(self.y * other.z - self.z * other.y, self.z * other.x - self.x * other.z, self.x * other.y - self.y * other.x);
    }

    pub fn unit(self: Vec3) Vec3 {
        return divideBy(self, self.length());
    }

    fn clamp(x: f32, min: f32, max: f32) f32 {
        if (x < min) return min;
        if (x > max) return max;
        return x;
    }

    fn floatToColor(val: f32) u32 {
        return @floatToInt(u32, 256.0 * clamp(val, 0.0, 0.999));
    }

    pub fn writeColor(pixel_color: Vec3, samples_per_pixel: u32) anyerror!void {
        var rf: f32 = pixel_color.x;
        var gf: f32 = pixel_color.y;
        var bf: f32 = pixel_color.z;

        // Divide the color by the number of samples and gamma-corrected for gamma = 2.0
        const scale: f32 = 1.0 / @intToFloat(f32, samples_per_pixel);
        rf = @sqrt(rf * scale);
        gf = @sqrt(gf * scale);
        bf = @sqrt(bf * scale);

        const r: u32 = floatToColor(rf);
        const g: u32 = floatToColor(gf);
        const b: u32 = floatToColor(bf);

        try stdout.print("{d} {d} {d}\n", .{ r, g, b });
    }

    pub fn random() Vec3 {
        return Vec3.init(zigray_utils.randomFloat(), zigray_utils.randomFloat(), zigray_utils.randomFloat());
    }

    pub fn randomBounded(min: f32, max: f32) Vec3 {
        return Vec3.init(zigray_utils.randomFloatBounded(min, max), zigray_utils.randomFloatBounded(min, max), zigray_utils.randomFloatBounded(min, max));
    }

    pub fn randomInUnitSphere() Vec3 {
        while (true) {
            var p: Vec3 = Vec3.randomBounded(-1.0, 1.0);
            if (p.lengthSquared() >= 1.0) continue;
            return p;
        }
    }

    pub fn expectEqual(expected: Vec3, actual: Vec3) anyerror!void {
        try testing.expectEqual(expected.x, actual.x);
        try testing.expectEqual(expected.y, actual.y);
        try testing.expectEqual(expected.z, actual.z);
    }
};

test "add" {
    const v1: Vec3 = Vec3.init(0.5, 0.0, 1.0);
    const v2: Vec3 = Vec3.init(0.5, 1.0, 0.0);
    const expected_result: Vec3 = Vec3.init(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);

    const result: Vec3 = v1.add(v2);

    try Vec3.expectEqual(expected_result, result);
}

test "sub" {
    const v1: Vec3 = Vec3.init(0.5, 0.0, 1.0);
    const v2: Vec3 = Vec3.init(0.5, 1.0, 0.0);
    const expected_result: Vec3 = Vec3.init(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);

    const result: Vec3 = v1.sub(v2);

    try Vec3.expectEqual(expected_result, result);
}

test "mult" {
    const v1: Vec3 = Vec3.init(0.5, 0.0, 1.0);
    const v2: Vec3 = Vec3.init(0.5, 1.0, 0.0);
    const expected_result: Vec3 = Vec3.init(v1.x * v2.x, v1.y * v2.y, v1.z * v2.z);

    const result: Vec3 = v1.mult(v2);

    try Vec3.expectEqual(expected_result, result);
}

test "multiplyBy" {
    const v1: Vec3 = Vec3.init(0.5, 0.0, 1.0);
    const factor: f32 = 0.5;
    const expected_result: Vec3 = Vec3.init(v1.x * factor, v1.y * factor, v1.z * factor);

    const result: Vec3 = v1.multiplyBy(factor);

    try Vec3.expectEqual(expected_result, result);
}

test "div" {
    const v1: Vec3 = Vec3.init(0.5, 0.0, 1.0);
    const v2: Vec3 = Vec3.init(0.5, 1.0, 0.0);
    const expected_result: Vec3 = Vec3.init(v1.x / v2.x, v1.y / v2.y, v1.z / v2.z);

    const result: Vec3 = v1.div(v2);

    try Vec3.expectEqual(expected_result, result);
}

test "divideBy" {
    const v1: Vec3 = Vec3.init(0.5, 0.0, 1.0);
    const divisor: f32 = 0.5;
    const expected_result: Vec3 = Vec3.init(v1.x / divisor, v1.y / divisor, v1.z / divisor);

    const result: Vec3 = v1.divideBy(divisor);

    try Vec3.expectEqual(expected_result, result);
}

test "length" {
    const v1: Vec3 = Vec3.init(0.5, 1.0, 0.75);

    const result: f32 = v1.length();

    try testing.expectEqual(result, 1.34629118);
}

test "dot product" {
    const v1 = Vec3.init(1.0, 0.0, 0.0);
    const v2 = Vec3.init(0.0, 1.0, 0.0);

    try testing.expect(v1.dot(v2) == 0.0);
}
