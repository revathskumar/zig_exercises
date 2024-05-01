const Self = @This();
const std = @import("std");
const print = std.debug.print;

server: std.net.Server,

pub fn init(ip: [4]u8, port: u16) !Self {
    std.debug.print("Init\n", .{});
    const address = std.net.Address.initIp4(ip, port);

    const server = try std.net.Address.listen(address, .{ .reuse_address = true });

    return Self{ .server = server };
}

pub fn deinit(self: *Self) void {
    std.debug.print("deinit\n", .{});
    self.server.deinit();
}

pub fn accept(self: *Self) !void {
    std.debug.print("Accept\n", .{});
    const conn = try self.server.accept();
    defer conn.stream.close();

    var buf: [1024]u8 = undefined;
    const msg_size = try conn.stream.read(buf[0..]);

    if (msg_size == 0) {
        return;
    }

    std.debug.print("Message received by Server :: {s}\n", .{buf[0..msg_size]});
}
