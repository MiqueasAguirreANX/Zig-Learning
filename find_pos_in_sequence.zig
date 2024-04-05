/// Given an increasing sequence where each element is an integer composed of digits
/// from a given set t.
/// For example, if t = { 1, 5 }, the sequence would be: 1, 5, 11, 15, 51, 55, 111, 115, ...
/// Another example, if t = { 4, 0, 2 }, the sequence would be: 0, 2, 4, 20, 22, 24, 40, 42, ...
/// Task
/// In this kata, you need to implement a function findpos(n, t) that receives a
/// integer n and a table t representing the set of digits, and returns
/// the position of n in the sequence.
///
const std = @import("std");
const ArrayList = std.ArrayList;
const HashMap = std.HashMap;
const rand = std.crypto.random;
const time = std.time;
const print = std.debug.print;
const fmt = std.fmt;

pub fn main() !void {}
