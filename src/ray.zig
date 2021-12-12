const std = @import("std");
const testing = std.testing;
const Vec3 = @import("vector.zig").Vec3;
const infinity = std.math.inf(f32);
const hittable = @import("hittable.zig");

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

    pub fn color(ray: Ray, world: *hittable.Hittable, depth: i32) Vec3 {
        // If we've exceeded the ray bounce limit, no more light is gathered.
        if (depth <= 0) {
            return Vec3.init(0.0, 0.0, 0.0);
        }

        const hit_record = world.hit(ray, 0, infinity);
        if (hit_record) |rec| {
            // return rec.normal.add(Vec3.init(1.0, 1.0, 1.0)).multiplyBy(0.5);
            const target: Vec3 = rec.point.add(rec.normal).add(Vec3.randomInUnitSphere());
            return color(Ray.init(rec.point, target.sub(rec.point)), world, depth - 1).multiplyBy(0.5); //ray(rec.p, target - rec.p), world);
        }

        const unit_direction: Vec3 = Vec3.unit(ray.direction);
        const hit_point: f32 = 0.5 * (unit_direction.y + 1.0);
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
