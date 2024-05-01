const std = @import("std");
const print = std.debug.print;
const TcpConnection = @import("tcp_connection.zig");

pub fn main() !void {
    var tcp_server: TcpConnection = TcpConnection.init([4]u8{ 127, 0, 0, 1 }, 8080) catch |err| {
        print("Error {any}\n", .{err});
        return;
    };
    defer tcp_server.deinit();

    std.debug.print("Accepting connections\n", .{});

    while (true) {
        try tcp_server.accept();
    }
}
