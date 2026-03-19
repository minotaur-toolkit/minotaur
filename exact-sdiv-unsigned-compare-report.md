## LLVM misses a non-power-of-two `sdiv exact` compare fold

### Reproducer

```llvm
define i1 @src(i64 %x) {
entry:
  %q = sdiv exact i64 %x, 24
  %r = icmp ugt i64 %q, 4611686018427387903
  ret i1 %r
}
```

### Expected

This is equivalent to:

```llvm
define i1 @tgt(i64 %x) {
entry:
  %r = icmp slt i64 %x, 0
  ret i1 %r
}
```

Reason:
- `%q = sdiv exact %x, 24` implies `%x` is divisible by `24`
- `%q >u 4611686018427387903` means `%q` is negative
- for positive divisor `24`, `%q < 0` iff `%x < 0`

Alive2 verifies `src => tgt`.

### What LLVM does

With LLVM 21.1.7:

```bash
opt -S -passes='instcombine,simplifycfg'
```

the function is left unchanged.

LLVM already handles:

```llvm
icmp slt i64 (sdiv exact i64 %x, 24), 0
  -> icmp slt i64 %x, 0
```

and it also handles power-of-two divisors like:

```llvm
sdiv exact i64 %x, 8
```

### Missed case

The missed case is:

```text
icmp ugt (sdiv exact x, C), K
```

where:
- `C` is positive and not a power of two
- `K` is large enough that the comparison is true iff the quotient is negative

So the missing canonicalization is:

```llvm
icmp ugt (sdiv exact %x, C_nonpow2), K_high
  -> icmp slt %x, 0
```

### Small boundary example

This one is valid:

```llvm
%q = sdiv exact i8 %x, 8
%r = icmp ugt i8 %q, 15
```

and folds to `icmp slt i8 %x, 0`.

But this one is not valid:

```llvm
%q = sdiv exact i8 %x, 8
%r = icmp ugt i8 %q, 14
```

Alive2 gives counterexample `%x = 120`.
