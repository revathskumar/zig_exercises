const std = @import("std");

pub fn main() !void {
    const address = std.net.Address.initIp4([4]u8{ 127, 0, 0, 1 }, 8080);

    while (true) {
        const conn = try std.net.tcpConnectToAddress(address);
        defer conn.close();

        const in = std.io.getStdIn();
        var buf = std.io.bufferedReader(in.reader());

        var r = buf.reader();
        std.debug.print("Write something: ", .{});

        var msg_buf: [4096]u8 = undefined;
        var msg = try r.readUntilDelimiterOrEof(&msg_buf, '\n');

        if (msg) |m| {
            _ = try conn.write(m);
        }
    }
}
