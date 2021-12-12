const std = @import("std");
const Vec3 = @import("vector.zig").Vec3;
const Ray = @import("ray.zig").Ray;
const material = @import("material.zig");

pub const HitRecord = struct {
    hit_point: f32,
    point: Vec3,
    normal: Vec3,
    front_face: bool,
    scatterable: *material.Scatterable,

    pub fn setFaceNormal(hit_record: HitRecord, ray: Ray, outward_normal: Vec3) HitRecord {
        const front_face: bool = Vec3.dot(ray.direction, outward_normal) < 0;
        const new_normal: Vec3 = if (front_face) outward_normal else outward_normal.mult(Vec3.init(-1.0, -1.0, -1.0));
        return HitRecord{ .hit_point = hit_record.hit_point, .front_face = front_face, .normal = new_normal, .point = hit_record.point, .scatterable = hit_record.scatterable };
    }
};

pub const Hittable = struct {
    hitFn: fn (h: *Hittable, ray: Ray, t_min: f32, t_max: f32) ?HitRecord,

    pub fn hit(self: *Hittable, ray: Ray, t_min: f32, t_max: f32) ?HitRecord {
        return self.hitFn(self, ray, t_min, t_max);
    }
};

pub const HittableList = struct {
    const ListType = std.ArrayList(*Hittable);

    list: ListType,
    hittable: Hittable,

    pub fn init() HittableList {
        return HittableList{
            .list = ListType.init(std.heap.page_allocator),
            .hittable = .{
                .hitFn = hit,
            },
        };
    }

    pub fn addHittable(self: *HittableList, ht: ?*Hittable) void {
        self.list.append(ht.?) catch unreachable;
    }

    pub fn hit(ht: *Hittable, ray: Ray, t_min: f32, t_max: f32) ?HitRecord {
        var self: *HittableList = @fieldParentPtr(HittableList, "hittable", ht);
        var record: HitRecord = undefined;
        var closest_so_far: f32 = t_max;
        var hit_anything: bool = false;
        for (self.list.items) |it| {
            const rec = it.hit(ray, t_min, closest_so_far);
            if (rec) |r| {
                hit_anything = true;
                closest_so_far = r.hit_point;
                record = r;
            }
        }
        return if (hit_anything) record else null;
    }
};
