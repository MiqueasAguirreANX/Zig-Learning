const std = @import("std");
const print = std.debug.print;
const time = std.time;
const Instant = time.Instant;
const Timer = time.Timer;
const ArrayList = std.ArrayList;

const Thread = std.Thread;
const Mutex = Thread.Mutex;
const spawn = Thread.spawn;
const SpawnConfig = Thread.SpawnConfig;

var mutex = Mutex{};
var cond = Thread.Condition{};

const SharedData = struct { suma: f64 = 0, cont: i64 = 0 };

var shared_data = SharedData{};

const array_size = 1_000_000;

const array_len: u32 = 4;

const TestPoint = struct {
    x: u32 = 0,
    y: f64 = 0,
};

var test_points = ArrayList(TestPoint).init(std.heap.page_allocator);

pub fn calculo(range_upper_limit: u32) !void {
    var list: [array_len][array_size]f32 = undefined;
    var threads: [array_len * 2]std.Thread = undefined;

    for (0..range_upper_limit) |_| {
        for (0..array_len) |i| {
            threads[i] = try Thread.spawn(.{}, fillList, .{&list[i]});
        }
        for (0..array_len) |y| {
            threads[y].join();
        }
        for (array_len..array_len * 2) |i| {
            threads[i] = try Thread.spawn(.{}, promedio, .{&list[i - array_len]});
        }
        for (array_len..array_len * 2) |y| {
            threads[y].join();
        }
    }
}

pub fn main() !void {
    var contador: u32 = 1;
    for (1..100) |_| {
        var total_count = 4_000_000 * contador;
        var range_upper_limit = (total_count / array_size) / array_len;
        shared_data.cont = 0;
        shared_data.suma = 0;
        const start = try Instant.now();
        try calculo(range_upper_limit);
        const end = try Instant.now();
        var prom: f64 = 0;
        if (shared_data.cont != 0) {
            const contF: f64 = @floatFromInt(shared_data.cont);
            prom = shared_data.suma / contF;
        }
        const elapsed1: f64 = @floatFromInt(end.since(start));
        print("# {d}: time elapsed is: {d:.3}s\n", .{
            contador,
            elapsed1 / time.ns_per_s,
        });
        test_points.append(TestPoint{ .x = contador, .y = elapsed1 }) catch unreachable;
        contador += 1;
    }

    print("test_points: {any}\n", .{test_points.items});
}

fn promedio(list: *[array_size]f32) !void {
    mutex.lock();
    defer mutex.unlock();
    for (0..array_size) |i| {
        shared_data.suma += list[i];
        shared_data.cont += 1;
    }
}

fn fillList(list: *[array_size]f32) !void {
    var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u32 = undefined;
        try std.os.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();
    for (0..array_size) |i| {
        const rand_n = rand.float(f32);
        list[i] = rand_n * 10;
    }
}
