const Vec3 = @import("vector.zig").Vec3;
const Ray = @import("ray.zig").Ray;
const hittable = @import("hittable.zig");

pub const Material = struct {
    ray: Ray,
    attenuation: Vec3,
    // scattered: bool,

    pub fn init(ray: Ray, attenuation: Vec3) Material {
        return Material{ .ray = ray, .attenuation = attenuation };
    }
};

pub const Scatterable = struct {
    scatterFn: fn (s: *Scatterable, ray: Ray, hit_record: hittable.HitRecord) ?Material,

    pub fn scatter(self: *Scatterable, ray: Ray, hit_record: hittable.HitRecord) ?Material {
        return self.scatterFn(self, ray, hit_record);
    }
};

pub const Lambertian = struct {
    albedo: Vec3,
    scatterable: Scatterable,

    pub fn init(albedo: Vec3) Lambertian {
        return Lambertian{ .albedo = albedo, .scatterable = Scatterable{ .scatterFn = scatter } };
    }

    pub fn scatter(sc: *Scatterable, ray: Ray, hit_record: hittable.HitRecord) ?Material {
        _ = ray;
        const self: *Lambertian = @fieldParentPtr(Lambertian, "scatterable", sc);
        var scatter_direction: Vec3 = hit_record.normal.add(Vec3.randomUnitVector());

        // Catch degenerate scatter direction
        if (scatter_direction.nearZero()) {
            scatter_direction = hit_record.normal;
        }

        const scattered = Ray.init(hit_record.point, scatter_direction);
        return Material.init(scattered, self.albedo);
    }
};

pub const Mirror = struct {
    albedo: Vec3,
    scatterable: Scatterable,

    pub fn init(albedo: Vec3) Mirror {
        return Mirror{ .albedo = albedo, .scatterable = Scatterable{ .scatterFn = scatter } };
    }

    pub fn scatter(sc: *Scatterable, ray: Ray, hit_record: hittable.HitRecord) ?Material {
        const self: *Metal = @fieldParentPtr(Metal, "scatterable", sc);
        const reflected: Vec3 = ray.direction.unit().reflect(hit_record.normal);
        const scattered: Ray = Ray.init(hit_record.point, reflected);

        if (scattered.direction.dot(hit_record.normal) > 0) {
            return Material.init(scattered, self.albedo);
        }
        return null;
    }
};

pub const Metal = struct {
    albedo: Vec3,
    scatterable: Scatterable,
    fuzziness: f32,

    pub fn init(albedo: Vec3, fuzz: f32) Metal {
        const fuzziness: f32 = if (fuzz < 1) fuzz else 1;
        return Metal{ .albedo = albedo, .fuzziness = fuzziness, .scatterable = Scatterable{ .scatterFn = scatter } };
    }

    pub fn scatter(sc: *Scatterable, ray: Ray, hit_record: hittable.HitRecord) ?Material {
        const self: *Metal = @fieldParentPtr(Metal, "scatterable", sc);
        const reflected: Vec3 = ray.direction.unit().reflect(hit_record.normal);
        const scattered: Ray = Ray.init(hit_record.point, reflected.add(Vec3.randomInUnitSphere().multiplyBy(self.fuzziness)));

        if (scattered.direction.dot(hit_record.normal) > 0) {
            return Material.init(scattered, self.albedo);
        }
        return null;
    }
};
