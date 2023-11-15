const std = @import("std");
test "simple string assignment" {
    var str: []const u8 = "Hello";
    // str = "Hello";
    str = "world";

    try std.testing.expectEqualStrings("world", str);
}
