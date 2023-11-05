const Self = @This();
const std = @import("std");

stream_server: std.net.StreamServer,

pub fn init() !Self {
    const address = std.net.Address.initIp4([4]u8{ 127, 0, 0, 1 }, 8080);

    var server = std.net.StreamServer.init(.{ .reuse_address = true });
    try server.listen(address);

    return Self{ .stream_server = server };
}

pub fn deinit(self: *Self) void {
    self.stream_server.deinit();
}

pub fn accept(self: *Self) !void {
    const conn = try self.stream_server.accept();
    defer conn.stream.close();

    _ = try conn.stream.write("Hello from Server");
    var buf: [1024]u8 = undefined;
    const msg_size = try conn.stream.read(buf[0..]);

    std.debug.print("Message received by Server :: {s}\n", .{buf[0..msg_size]});
}
