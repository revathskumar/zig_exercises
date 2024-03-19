const std = @import("std");

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    // std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var progress = [10]u8{ '.', '.', '.', '.', '.', '.', '.', '.', '.', '.' };

    for (1..101) |i| {
        if (i % 10 == 0) {
            const a: usize = i / 10;
            progress[a - 1] = ':';
        }
        try stdout.print("\u{001b}[1AProcessing : [{s}] {d}%\n", .{ progress, i });

        try bw.flush();
        std.time.sleep(60 * 1000 * 1000);
    }

    try bw.flush(); // don't forget to flush!
}
