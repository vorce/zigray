const Vec3 = @import("vector.zig").Vec3;
const Ray = @import("ray.zig").Ray;

pub const Camera = struct {
    origin: Vec3,
    horizontal: Vec3,
    vertical: Vec3,
    lower_left_corner: Vec3,

    pub fn init(viewport_height: f32, viewport_width: f32, focal_length: f32) Camera {
        const origin: Vec3 = Vec3.init(0.0, 0.0, 0.0);
        const horizontal: Vec3 = Vec3.init(viewport_width, 0.0, 0.0);
        const vertical: Vec3 = Vec3.init(0.0, viewport_height, 0.0);
        return Camera{
            .origin = origin,
            .horizontal = horizontal,
            .vertical = vertical,
            .lower_left_corner = origin.sub(horizontal.divideBy(2.0)).sub(vertical.divideBy(2.0)).sub(Vec3.init(0.0, 0.0, focal_length)),
        };
    }

    pub fn getRay(self: Camera, u: f32, v: f32) Ray {
        return Ray.init(self.origin, self.lower_left_corner.add(self.horizontal.multiplyBy(u)).add(self.vertical.multiplyBy(v)).sub(self.origin));
    }
};
