const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const ally = gpa.allocator();

    const first: []const u8 = "Hello ";
    const second: []const u8 = "World !";

    const words = [_][]const u8{ first, second, "ABC", "def" };

    const result = try concat(ally, &words);
    defer ally.free(result);

    std.debug.print("{!s}", .{result});
}

pub fn concat(allocator: std.mem.Allocator, strs: []const []const u8) ![]const u8 {
    return try std.mem.concat(allocator, u8, strs);
}

test "simple string concat" {
    var first: []const u8 = "Hello";
    var second: []const u8 = " World!";
    const allocator = std.testing.allocator;
    const result = try concat(allocator, &[_][]const u8{ first, second });
    defer allocator.free(result);

    try std.testing.expectEqualStrings("Hello World!", result);
}
