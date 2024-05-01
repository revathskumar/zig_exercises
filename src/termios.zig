const std = @import("std");
const print = std.debug.print;

const B_BLUE = 44;
const B_CYAN = 46;
const B_WHITE = 47;

// Foreground colors low intensity
const F_BLACK = 30;
const F_CYAN = 36;
const F_WHITE = 37;

const FH_WHITE = 97;

const TIOCGWINSZ = @as(c_int, 0x5413); // 21523
// const TIOCGWINSZ = 0x5413;
const WinSize = struct { ws_row: u16, ws_col: u16, ws_xpixel: u16, ws_ypixel: u16 };

const stdout_file = std.io.getStdOut().writer();
var bw = std.io.bufferedWriter(stdout_file);
const stdout = bw.writer();

pub fn main() !void {
    try main_screen();
}
fn main_screen() !void {
    var rows: u32 = 0;
    var columns: u32 = 0;
    const stdin = std.io.getStdIn();
    // const stdinReader = try stdin.reader();
    const stdin_handle: std.os.linux.fd_t = stdin.handle;
    // const outw = std.io.getStdOut().writer();
    // try outw.print("Stuff\n", .{});
    var win: WinSize = WinSize{ .ws_row = 0, .ws_col = 0, .ws_xpixel = 0, .ws_ypixel = 0 };

    // const stdin_handle: fs.File = std.io.get();
    // const stdin_handle: std.os.linux.fd_t = std.io.getStdOut().handle;
    // print("TIOCGWINSZ : {any}\n", .{TIOCGWINSZ});
    // print("c_int : {any}\n", .{@as(c_int, 21523)});
    // print("c_long : {any}\n", .{@as(c_long, @as(c_int, 21523))});
    // print("bitcast : {any}\n", .{@as(c_ulong, @bitCast(@as(c_long, @as(c_int, 21523))))});
    // print("TIOCGWINSZ : {any}\n", .{@bitCast(TIOCGWINSZ)});
    // print("stdin_handle : {any}\n", .{stdin_handle});
    // const termios = std.os.linux.termios;
    // try std.os.linux.tcgetattr(stdin_handle, &termios);
    // const original_state = termios;
    // try startRawMode(stdin_handle, &termios);
    // borderChar();
    try screencol(B_BLUE);
    try gotoxy(1, 1);
    try outputcolor(0, F_WHITE);

    try getDimension(stdin_handle, &win);
    rows = @as(u32, @intCast(win.ws_row));
    columns = @as(u32, @intCast(win.ws_col));

    try outputcolor(F_WHITE, B_CYAN);

    for (0..columns) |i| {
        try gotoxy(@as(u32, @intCast(i)), 1);
        try stdout.print(" ", .{});
    }

    // // bottom line
    try outputcolor(F_WHITE, B_WHITE);
    for (0..columns) |i| {
        try gotoxy(@as(u32, @intCast(i)), rows - 1);
        try stdout.print(" ", .{});
    }

    try outputcolor(F_BLACK, B_CYAN);
    try gotoxy(1, 1);
    try stdout.print(" File  Options  Help", .{});

    try outputcolor(FH_WHITE, B_BLUE);
    try gotoxy(2, 3);
    try stdout.print("Selection Menu", .{});

    try gotoxy(2, 4);
    try stdout.print("==============", .{});

    try gotoxy(2, 5);
    try stdout.print("Option 1", .{});

    try gotoxy(2, 6);
    try stdout.print("Option 2", .{});

    try gotoxy(columns - 6, 1);
    try stdout.print("{d}:{d}", .{ columns, rows });

    try outputcolor(F_BLACK, B_WHITE);

    try gotoxy(1, rows - 1);
    try stdout.print("- Coded by RSK", .{});

    try bw.flush();

    var buf: u8 = undefined;
    var buf_reader = std.io.bufferedReader(stdin.reader());
    var in_stream = buf_reader.reader();
    buf = try in_stream.readByte();

    try outputcolor(FH_WHITE, B_BLUE);
    try gotoxy(2, 7);
    try stdout.print("Pressed {c}", .{buf});

    try bw.flush();
    // _ = std.os.getStdIn().read(.{ buffer = buf, bufferLen = 1 });

    // print("std in read {s}\n", .{buf});

    // print("winSize : Rows {d}\n", .{rows});
    // print("winSize : Columns {d}\n", .{columns});
}

//Sets the cursor at the desired position.
fn gotoxy(x: u32, y: u32) !void {
    try stdout.print("\u{001b}[{d};{d}f", .{ y, x });
}

//Changes format foreground and background colors of display.
fn outputcolor(foreground: u32, background: u32) !void {
    try stdout.print("\u{001b}[{d};{d}m", .{ foreground, background });
}

//change color of entire screen
fn screencol(x: u32) !void {
    try gotoxy(0, 0);
    try outputcolor(0, x);
    try stdout.print("\u{001b}[2J", .{});
    try outputcolor(0, 0);
}

fn startRawMode(stdin_handle: std.os.fd_t, termios: *std.os.termios) !void {
    termios.*.cflag &= ~@as(u32, (8)); // Echo
    try std.os.tcsetattr(stdin_handle, std.os.TCSA.FLUSH, termios.*);
    print("set for RAW mode\n", .{});
    print("{any} \n", .{termios});
}

fn endRawMode(stdin_handle: std.os.fd_t, original_state: std.os.termios) !void {
    try std.os.tcsetattr(stdin_handle, std.os.TCSA.FLUSH, original_state);
    print("end for RAW mode {any}\n", .{original_state});
}

fn clearScreen() void {
    print("\u{001b}[2J\u{001b}[1;1H", .{});
}

fn borderChar() void {
    print("\u{001b}(0 HELLO \u{001b}(B\n", .{});
}

fn getDimension(stdin_handle: std.os.linux.fd_t, win: *WinSize) IoCtlError!void {
    while (true) {
        // const errno = std.c.ioctl(0, 21523, &max);
        const errno = std.os.linux.ioctl(stdin_handle, TIOCGWINSZ, @intFromPtr(win));
        switch (std.posix.errno(errno)) {
            .SUCCESS => return,
            .INVAL => unreachable, // Bad parameters.
            .NOTTY => unreachable,
            .NXIO => unreachable,
            .BADF => unreachable, // Always a race condition.
            .FAULT => unreachable, // Bad pointer parameter.
            .INTR => continue,
            .IO => return error.FileSystem,
            .NODEV => return error.InterfaceNotFound,
            else => |err| return std.posix.unexpectedErrno(err),
        }
    }
}

pub const IoCtlError = error{
    FileSystem,
    InterfaceNotFound,
} || std.posix.UnexpectedError;
