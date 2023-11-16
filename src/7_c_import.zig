const std = @import("std");

const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("sys/xattr.h");
});

pub fn main() !void {
    const chars: i32 = c.printf("Hello using c printf\n");
    _ = c.printf("chars via printf :: %d\n", chars);
    std.debug.print("chars :: {d}\n", .{chars});

    const xattr = c.listxattr("./src/main.zig", null, 0);
    std.debug.print("xattr :: {d}\n", .{xattr});
}
