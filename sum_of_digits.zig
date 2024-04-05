/// Sum of Digits
/// Given n, take the sum of the digits of n.
/// If that value has more than one digit, continue reducing in this way
/// until a single-digit number is produced.
/// The input will be a non-negative integer
///
///
const std = @import("std");
const ArrayList = std.ArrayList;
const rand = std.crypto.random;
const time = std.time;
const print = std.debug.print;
const fmt = std.fmt;

var buffer: [100]u8 = undefined;

fn sum_of_digits(n: u32) !u32 {
    var sum: u32 = 0;
    var character: u8 = 0;
    var str = fmt.bufPrintIntToSlice(&buffer, n, 10, fmt.Case.lower, .{});
    for (str) |c| {
        character = try fmt.charToDigit(c, 10);
        sum += @intCast(character);
    }

    return sum;
}

pub fn main() !void {
    var num: u32 = 523;
    for (0..100) |i| {
        buffer[i] = '0';
    }
    var suma: u32 = 0;
    var condition = true;
    while (condition) {
        var resp = try sum_of_digits(num);
        suma += resp;
        if (resp < 10) {
            condition = false;
        }
        num = resp;
    }
    print("Sum of digits: {d}\n", .{suma});
}
