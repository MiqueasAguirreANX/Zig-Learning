///
/// Reagent formula agent
/// Now we will confect a reagent.
/// There are eight materials to choose from, numbered 1,2,..., 8 respectively.
/// Rules:
/// material1 and material2 cannot be selected at the same time
/// material3 and material4 cannot be selected at the same time
/// material5 and material6 must be selected at the same time
/// material7 or  material8 must be selected(at least one, or both)
///
///
///
const std = @import("std");
const ArrayList = std.ArrayList;
const rand = std.crypto.random;
const time = std.time;
const print = std.debug.print;

fn conditionOne(formula: *ArrayList(u32)) bool {
    var hasOne = false;
    var hasTwo = false;
    for (formula.items) |item| {
        if (item == 1) {
            hasOne = true;
        }
        if (item == 2) {
            hasTwo = true;
        }
        if (hasOne and hasTwo) {
            return false;
        }
    }
    return true;
}

fn conditionTwo(formula: *ArrayList(u32)) bool {
    var hasThree = false;
    var hasFour = false;
    for (formula.items) |item| {
        if (item == 3) {
            hasThree = true;
        }
        if (item == 4) {
            hasFour = true;
        }
        if (hasThree and hasFour) {
            return false;
        }
    }
    return true;
}

fn conditionThree(formula: *ArrayList(u32)) bool {
    var hasFive = false;
    var hasSix = false;
    for (formula.items) |item| {
        if (item == 5) {
            hasFive = true;
        }
        if (item == 6) {
            hasSix = true;
        }
        if (hasFive and hasSix) {
            return true;
        }
    }
    return false;
}

fn conditionFour(formula: *ArrayList(u32)) bool {
    for (formula.items) |item| {
        if (item == 7 or item == 8) {
            return true;
        }
    }
    return false;
}

fn confect(formula: *ArrayList(u32)) bool {
    return conditionOne(formula) and conditionTwo(formula) and conditionThree(formula) and conditionFour(formula);
}

pub fn main() !void {
    var formula = ArrayList(u32).init(std.heap.page_allocator);
    defer formula.deinit();
    var res_true = true;
    while (res_true) {
        var size = rand.intRangeAtMost(u32, 1, 20);
        for (0..size) |_| {
            try formula.append(rand.intRangeAtMost(u32, 1, 8));
        }
        print("formula: {any}\n", .{formula.items});
        const res = confect(&formula);
        print("res: {any}\n", .{res});
        time.sleep(1 * time.ns_per_s);
        if (res) {
            res_true = false;
        }
        formula.clearRetainingCapacity();
    }
}
