const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var buf: [10]u8 = undefined;

    // const fd: usize = std.os.linux.open("data/abc.txt", .{ .CREAT = false, .APPEND = true }, 0o0644);
    // switch (std.posix.errno(fd)) {
    //     .SUCCESS => ,
    // }
    const fd = open() catch |err| {
        print("open err {any}: \n", .{err});
        return;
    };
    defer std.posix.close(fd);
    // print("fd tag name : {s}\n", .{@tagName(std.posix.errno(fd))});
    print("fd {d}\n", .{fd});
    // if (fd == -1) {
    //     print("Error Number {d}\n", .{fd});
    //     return;
    // }
    // _ = std.os.linux.read(@as(i32, @intCast(fd)), &buf, 19);
    _ = try std.posix.read(fd, &buf);
    // _ = std.os.linux.close(@as(i32, @intCast(fd)));
    // _ = std.posix.close(fd);
    print("text from file : {s}\n", .{buf[0..]});
}

fn open() error{Unexpected}!std.posix.fd_t {
    while (true) {
        const fd: usize = std.os.linux.open("data/abc.txt", .{ .CREAT = false, .APPEND = true }, 0o0644);
        switch (std.posix.errno(fd)) {
            .SUCCESS => return @intCast(fd),
            .INTR => continue,
            else => |err| return std.posix.unexpectedErrno(err),
        }
    }
}
