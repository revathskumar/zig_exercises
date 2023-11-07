const std = @import("std");
const fmtIntSizeBin = std.fmt.fmtIntSizeBin;

pub fn main() !void {
    var file = try std.fs.cwd().openFile("file.txt", .{});
    defer file.close();

    const stat = try file.stat();
    std.debug.print("Kind :: {any}\n", .{stat.kind});
    std.debug.print("Size :: {any}\n", .{stat.size});
    std.debug.print("ctime :: {any}\n", .{stat.ctime});
    std.debug.print("mtime :: {any}\n", .{stat.mtime});
    std.debug.print("atime :: {any}\n", .{stat.atime});
}
