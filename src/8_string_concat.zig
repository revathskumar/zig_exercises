const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const ally = gpa.allocator();

    const first: []const u8 = "Hello ";
    const second: []const u8 = "World !";

    const result = try concat(ally, first, second);
    defer ally.free(result);

    std.debug.print("{!s}", .{result});
}

pub fn concat(allocator: std.mem.Allocator, first: []const u8, second: []const u8) ![]const u8 {
    const result = try allocator.alloc(u8, first.len + second.len);
    std.mem.copyForwards(u8, result[0..first.len], first);
    std.mem.copyForwards(u8, result[first.len..], second);
    return result;
}

test "simple string concat" {
    var first: []const u8 = "Hello";
    var second: []const u8 = " World!";
    const allocator = std.testing.allocator;
    const result = try concat(allocator, first, second);
    defer allocator.free(result);

    try std.testing.expectEqualStrings("Hello World!", result);
}
