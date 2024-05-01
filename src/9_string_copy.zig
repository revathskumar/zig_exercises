const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const ally = gpa.allocator();

    const first: []const u8 = "Hello ";
    // const second: []const u8 = "World !";

    const result = try copy(ally, first);
    defer ally.free(result);

    std.debug.print("{!s}", .{result});
}

pub fn copy(allocator: std.mem.Allocator, first: []const u8) ![]u8 {
    const result = try allocator.alloc(u8, first.len);
    std.mem.copyForwards(u8, result, first);
    return result;
}

test "simple string copy" {
    var str: []const u8 = "Hello";
    const allocator = std.testing.allocator;
    const result = try copy(allocator, str);
    defer allocator.free(result);
    // str = "Hello";
    // str = "world";

    try std.testing.expectEqualStrings(str, result);
}
