function int64ToUint64String(num) {
    var out = num;
    if (num < 0) {
        // 2^64 - > 18446744073709551616
        out = BigInt(num) + 18446744073709551616n;
    }
    return out.toString();
}
