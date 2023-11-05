const std = @import("std");
const TcpConnection = @import("tcp_connection.zig");

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    var tcp_server: TcpConnection = try TcpConnection.init();
    defer tcp_server.deinit();

    const client_thread = try std.Thread.spawn(.{}, sendMsg, .{tcp_server.stream_server.listen_address});
    defer client_thread.join();

    try tcp_server.accept();

    try bw.flush(); // don't forget to flush!
}

fn sendMsg(server_address: std.net.Address) !void {
    const conn = try std.net.tcpConnectToAddress(server_address);
    defer conn.close();

    _ = try conn.write("Hello from client");

    var buf: [1024]u8 = undefined;
    const msg_size = try conn.read(buf[0..]);

    std.debug.print("Message received by client :: {s}\n", .{buf[0..msg_size]});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
