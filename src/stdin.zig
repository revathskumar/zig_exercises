const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    const stdin = std.io.getStdIn();

    var buf: u8 = undefined;
    var buf_reader = std.io.bufferedReader(stdin.reader());
    var in_stream = buf_reader.reader();

    while (true) {
        print("Press any key and enter :\n", .{});

        buf = try in_stream.readByte();
        print("from std in : {c}\n", .{buf});
        if (buf == 'q') {
            print("You Pressed q! \n Exiting!\n", .{});
            break;
        } else {
            print("Press q to exit!\n", .{});
        }
    }
}
