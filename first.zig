const std = @import("std");
const print = std.debug.print;
const time = std.time;
const Instant = time.Instant;
const Timer = time.Timer;

pub fn main() !void {
    var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u32 = undefined;
        try std.os.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();
    const arraySize = 2000000;

    var list: [arraySize]f32 = undefined;
    var suma: f64 = 0;
    var cont: i32 = 0;
    const start = try Instant.now();
    for (0..500) |_| {
        for (0..arraySize) |i| {
            const rand_n = rand.float(f32);
            list[i] = rand_n * 10;
        }
        for (list) |n| {
            suma += n;
            cont += 1;
        }
    }

    var prom: f64 = 0;
    if (cont != 0) {
        const contF: f64 = @floatFromInt(cont);
        prom = suma / contF;
    }
    const end = try Instant.now();
    print("cont: {d:.2}\n", .{cont});
    print("promedio: {d:.2}\n", .{prom});

    const elapsed1: f64 = @floatFromInt(end.since(start));
    print("Time elapsed is: {d:.3}ms\n", .{
        elapsed1 / time.ns_per_ms,
    });
}
