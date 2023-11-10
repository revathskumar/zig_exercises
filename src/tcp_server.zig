const std = @import("std");
const TcpConnection = @import("tcp_connection.zig");

pub fn main() !void {
    var tcp_server: TcpConnection = try TcpConnection.init([4]u8{ 127, 0, 0, 1 }, 8080);
    defer tcp_server.deinit();

    std.debug.print("Accepting connections\n", .{});

    while (true) {
        try tcp_server.accept();
    }
}
