const std = @import("std");
const fmtIntSizeBin = std.fmt.fmtIntSizeBin;

pub fn main() !void {
    var file = try std.fs.cwd().openFile("file.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        std.debug.print("{s}\n", .{line});
    }
}

test "read file content: using read" {
    var file = try std.fs.cwd().openFile("file.txt", .{});
    defer file.close();

    var buf: [1024]u8 = undefined;
    var buf_reader = std.io.bufferedReader(file.reader());
    const size = try buf_reader.read(&buf);

    try std.testing.expectEqualStrings(
        \\hello
        \\
        \\world
    , buf[0..size]);
}

test "read file content: using readUntilDelimiterOrEof" {
    var file = try std.fs.cwd().openFile("file.txt", .{});
    defer file.close();

    var buf: [12]u8 = undefined;
    var buf_reader = std.io.bufferedReader(file.reader());
    // _ = try buf_reader.read(&buf);
    var in_stream = buf_reader.reader();

    // const allocator = std.mem.Allocator();
    const allocator = std.heap.page_allocator;
    // const allocator = std.testing.allocator;
    var content = std.ArrayList(u8).init(allocator);
    defer content.deinit();

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        // std.debug.print("{s}\n", .{line});
        _ = try content.writer().write(line);
    }

    const str: []const u8 = try allocator.dupe(u8, content.items);

    try std.testing.expectEqualStrings("helloworld", str);
}
