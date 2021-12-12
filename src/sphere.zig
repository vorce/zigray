const Vec3 = @import("vector.zig").Vec3;
const Ray = @import("ray.zig").Ray;
const h = @import("hittable.zig");
const Hittable = h.Hittable;
const HitRecord = h.HitRecord;
const material = @import("material.zig");

pub const Sphere = struct {
    center: Vec3,
    radius: f32,
    hittable: Hittable,
    scatterable: *material.Scatterable,

    pub fn init(center: Vec3, radius: f32, scatterable: *material.Scatterable) Sphere {
        return Sphere{ .center = center, .radius = radius, .hittable = Hittable{ .hitFn = hit }, .scatterable = scatterable };
    }

    fn hit(ht: *Hittable, ray: Ray, t_min: f32, t_max: f32) ?HitRecord {
        const self: *Sphere = @fieldParentPtr(Sphere, "hittable", ht);
        const oc: Vec3 = ray.origin.sub(self.center);
        const a: f32 = ray.direction.lengthSquared();
        const half_b: f32 = oc.dot(ray.direction);
        const c: f32 = oc.lengthSquared() - (self.radius * self.radius);

        const discriminant: f32 = (half_b * half_b) - (a * c);

        if (discriminant < 0) return null;
        const sqrtd: f32 = @sqrt(discriminant);

        // Find the nearest root that lies in the acceptable range.
        var root: f32 = (-half_b - sqrtd) / a;
        if (root < t_min or t_max < root) {
            root = (-half_b + sqrtd) / a;
            if (root < t_min or t_max < root) {
                return null;
            }
        }

        var hit_record: HitRecord = undefined;
        hit_record.hit_point = root;
        hit_record.point = ray.at(hit_record.hit_point);
        hit_record.normal = hit_record.point.sub(self.center).divideBy(self.radius);
        hit_record.scatterable = self.scatterable;

        const outward_normal: Vec3 = hit_record.point.sub(self.center).divideBy(self.radius);
        return hit_record.setFaceNormal(ray, outward_normal);
    }
};
