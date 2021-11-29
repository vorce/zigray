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

    pub fn hitSphere(ray: Ray, sphere_center: Vec3, radius: f32) f32 {
        const oc: Vec3 = ray.origin.sub(sphere_center);
        const a: f32 = ray.direction.lengthSquared();
        const half_b: f32 = oc.dot(ray.direction);
        const c: f32 = oc.lengthSquared() - (radius * radius);
        const discriminant: f32 = (half_b * half_b) - (a * c);

        if (discriminant < 0) {
            return -1.0;
        } else {
            return (-half_b - @sqrt(discriminant)) / a;
        }
    }

    pub fn color(ray: Ray) Vec3 {
        var hit_point: f32 = ray.hitSphere(Vec3.init(0.0, 0.0, -1.0), 0.5);
        if (hit_point > 0.0) {
            const normal: Vec3 = ray.at(hit_point).sub(Vec3.init(0.0, 0.0, -1.0)).unit();
            return Vec3.init(normal.x + 1.0, normal.y + 1.0, normal.z + 1.0).multiplyBy(0.5);
        }

        const unit_direction: Vec3 = Vec3.unit(ray.direction);
        hit_point = 0.5 * (unit_direction.y + 1.0);
        const fromColor: Vec3 = Vec3.init(1.0, 1.0, 1.0);
        const toColor: Vec3 = Vec3.init(0.5, 0.7, 1.0);

        return fromColor.multiplyBy(1.0 - hit_point).add(toColor.multiplyBy(hit_point));
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
