const Vec3 = @import("vector.zig").Vec3;
const Ray = @import("ray.zig").Ray;
const zigray_utils = @import("util.zig");

pub const Camera = struct {
    origin: Vec3,
    horizontal: Vec3,
    vertical: Vec3,
    lower_left_corner: Vec3,

    pub fn init(look_from: Vec3, look_at: Vec3, vup: Vec3, vertical_field_of_view: f32, aspect_ratio: f32) Camera {
        const theta: f32 = zigray_utils.degreesToRadians(vertical_field_of_view);
        const height: f32 = zigray_utils.tan(theta / 2.0);
        const viewport_height: f32 = 2.0 * height;
        const viewport_width: f32 = aspect_ratio * viewport_height;

        const w: Vec3 = look_from.sub(look_at).unit();
        const u: Vec3 = vup.cross(w).unit();
        const v: Vec3 = w.cross(u);

        const horizontal: Vec3 = u.multiplyBy(viewport_width);
        const vertical: Vec3 = v.multiplyBy(viewport_height);

        return Camera{
            .origin = look_from,
            .horizontal = horizontal,
            .vertical = vertical,
            .lower_left_corner = look_from.sub(horizontal.divideBy(2.0)).sub(vertical.divideBy(2.0)).sub(w),
        };
    }

    pub fn getRay(self: Camera, s: f32, t: f32) Ray {
        return Ray.init(self.origin, self.lower_left_corner.add(self.horizontal.multiplyBy(s)).add(self.vertical.multiplyBy(t)).sub(self.origin));
    }
};
