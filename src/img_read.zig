const std = @import("std");
const print = std.debug.print;
const fmtIntSizeBin = std.fmt.fmtIntSizeBin;

pub fn main() !void {
    var file = std.fs.cwd().openFile("data/tiny.png", .{}) catch |err| {
        std.debug.print("File open failed :: {}\n", .{err});
        return;
    };
    defer file.close();

    const stat = try file.stat();
    print("Size :: {any}\n", .{stat.size});
    print("Human readable Size (SI) :: {}\n", .{std.fmt.fmtIntSizeDec(stat.size)});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    // var buf: [8]u8 = undefined;
    // var buf = try allocator.alloc(usize, 8);
    // defer allocator.free(buf);
    var buf = std.ArrayList(u8).init(allocator);
    defer buf.deinit();

    try in_stream.readAllArrayList(&buf, stat.size);

    // const writer = buf.writer();

    // buf.append(try in_stream.readByte());
    // buf.append(try in_stream.readByte());
    // buf[0] = try in_stream.readByte();
    // buf[1] = try in_stream.readByte();
    // buf[2] = try in_stream.readByte();
    // buf[3] = try in_stream.readByte();
    // buf[4] = try in_stream.readByte();
    // buf[5] = try in_stream.readByte();
    // buf[6] = try in_stream.readByte();
    // buf[7] = try in_stream.readByte();
    // buf.appendSlice(try in_stream.readBytesNoEof(8));
    // print("{}\n", .{std.fmt.fmtSliceHexLower(&buf)});
    print("{any}\n", .{buf});
    print("PNG signature :: {s}\n", .{buf.items[0..7]});
    print("length of first chunk :: {}\n", .{std.fmt.fmtSliceHexLower(buf.items[8..12])});
    print("data of first chunk :: {}, ASCII :: {s}\n", .{ std.fmt.fmtSliceHexLower(buf.items[12..16]), buf.items[12..16] });
    print("Chunk data :: {}\n", .{std.fmt.fmtSliceHexLower(buf.items[8..21])});
    // print("{}\n", .{buf.len});

    // const data = "\x00\x05\x48\x65\x6c\x6c\x6f\x01\x03\x61\x6c\x6c";
    // print("{s}\n", .{data});
    // while(true) {
    //     try in_stream.readByte()
    // }

    // while (try in_stream.readAll(&buf)) |bytes| {
    //     // print("{s}\n", .{bytes});

    //     print("{}\n", .{std.fmt.fmtSliceHexLower(bytes)});
    // }

    // while (try in_stream.readAll(&buf)) |line| {
    //     print("0x{}\n", .{std.fmt.fmtSliceHexLower(line)});
    // }
}
