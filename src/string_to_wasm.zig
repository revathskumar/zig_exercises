// const std = @import("std");

// const c = @cImport({
//     @cInclude("stdio.h");
// });

extern fn print(message: [*]const u8, length: u64) void;

export fn hello() void {
    const message: []const u8 = "Hello from Zig!";
    print(message.ptr, message.len);
}
