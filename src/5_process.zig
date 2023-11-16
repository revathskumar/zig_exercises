const std = @import("std");

pub fn main() !void {
    const posixUser = std.process.posixGetUserInfo("username") catch {
        std.debug.print("posix user not found\n", .{});
        return;
    };
    const user = std.process.getUserInfo("abc") catch {
        std.debug.print("user not found\n", .{});
        return;
    };

    std.debug.print("posix user info {any}\n", .{posixUser});
    std.debug.print("user info {any}\n", .{user});
    std.debug.print("total system memory {any}\n", .{std.process.totalSystemMemory()});
    std.debug.print("get base address {any}\n", .{std.process.getBaseAddress()});
    // std.debug.print("get cwd {any}\n", .{cwd});
}
