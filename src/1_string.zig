const std = @import("std");
test "simple string assignment" {
    var str: []const u8 = "Hello";
    // str = "Hello";
    str = "world";

    try std.testing.expectEqualStrings("world", str);
}

// test "string concat" {
//     const hello: []const u8 = "Hello";
//     const world: []const u8 = "World";
//     // str = "Hello";
//     // str = "world";

//     try std.testing.expectEqualStrings("Hello World", hello ++ world);
// }

test "string : array literal" {
    const hello = [_]u8{ 'h', 'e', 'l', 'l', 'o' };

    try std.testing.expectEqualStrings("hello", &hello);
}
test "string : concat at comptime" {
    try std.testing.expectEqualStrings("Hello World", "Hello" ++ " " ++ "World");
}
