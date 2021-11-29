const std = @import("std");
const testing = std.testing;
const Vec3 = @import("vector.zig").Vec3;

pub const Ray = struct {
    origin: Vec3,
    direction: Vec3,

    pub fn init(origin: Vec3, direction: Vec3) Ray {
        return Ray{
            .origin = origin,
            .direction = direction,
        };
    }

    pub fn at(self: Ray, distance: f32) Vec3 {
        return self.origin.add(self.direction.multiplyBy(distance));
    }
};

test "at" {
    const origin: Vec3 = Vec3.init(0.0, 0.0, 0.0);
    const direction: Vec3 = Vec3.init(1.0, 0.0, 0.0);
    const ray: Ray = Ray.init(origin, direction);
    const distance: f32 = 0.5;
    const expected_result: Vec3 = Vec3.init(0.5, 0.0, 0.0);

    const result: Vec3 = ray.at(distance);

    try Vec3.expectEqual(expected_result, result);
}
