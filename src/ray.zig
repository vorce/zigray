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

    pub fn hitSphere(ray: Ray, sphere_center: Vec3, radius: f32) bool {
        const oc: Vec3 = ray.origin.sub(sphere_center);
        const a: f32 = ray.direction.dot(ray.direction);
        const b: f32 = oc.dot(ray.direction) * 2.0;
        const c: f32 = oc.dot(oc) - (radius * radius);
        const discriminant: f32 = (b * b) - (a * c * 4.0);
        return discriminant > 0.0;
    }

    pub fn color(ray: Ray) Vec3 {
        if (ray.hitSphere(Vec3.init(0.0, 0.0, -1.0), 0.5)) {
            return Vec3.init(1.0, 0.0, 0.0);
        }

        const unit_direction: Vec3 = Vec3.unit(ray.direction);
        const distance: f32 = 0.5 * (unit_direction.y + 1.0);
        const fromColor: Vec3 = Vec3.init(1.0, 1.0, 1.0);
        const toColor: Vec3 = Vec3.init(0.5, 0.7, 1.0);

        return fromColor.multiplyBy(1.0 - distance).add(toColor.multiplyBy(distance));
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
