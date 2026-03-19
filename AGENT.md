# Minotaur Agent Notes

This file is a short handoff for future agents working in this repository.

## Repo and Toolchain

- Repo root: `/localdev/zhengyangliu/minotaur`
- Main branch is the active branch.
- Frozen LLVM toolchain:
  - source/build root: `/localdev/zhengyangliu/llvm-frozen-21.1.7`
  - clang path: `/localdev/zhengyangliu/llvm-frozen-21.1.7/build/bin/clang`
  - clang++ path: `/localdev/zhengyangliu/llvm-frozen-21.1.7/build/bin/clang++`
  - `lld` and `ld.lld` are built in `/localdev/zhengyangliu/llvm-frozen-21.1.7/build/bin`
- Minotaur build dir:
  - `/localdev/zhengyangliu/minotaur/build-llvm21-freeze`
- Compiler wrappers:
  - `/localdev/zhengyangliu/minotaur/build-llvm21-freeze/minotaur-cc`
  - `/localdev/zhengyangliu/minotaur/build-llvm21-freeze/minotaur-c++`

## SPEC CPU2026 Workflow

- Use SPEC CPU2026 at:
  - `/localdev/zhengyangliu/cpu2026`
- Use rate suites only:
  - `intrate`
  - `fprate`
- Do not use speed suites unless explicitly requested.
- Benchmark build flags requested by the user:
  - `-O3 -flto -march=native`
- For LTO linking, use:
  - `-fuse-ld=lld`
- Reference config source:
  - `/localdev/zhengyangliu/tracing-automation/workloads/spec2k26.just`
- Current temporary config used for CPU2026 builds:
  - `/tmp/minotaur-cpu2026-llvm21.cfg`

## SPEC CPU2026 Build Command

```bash
cd /localdev/zhengyangliu/cpu2026
source shrc
ulimit -s unlimited
runcpu --action build --config /tmp/minotaur-cpu2026-llvm21.cfg --ignore_errors intrate fprate
```

## Cache / Redis

- Extraction runs should use:
  - `ENABLE_MINOTAUR=ON`
  - `MINOTAUR_NO_INFER=ON`
- Cache inference thread count requested by the user:
  - `128`
- Example:

```bash
cd /localdev/zhengyangliu/minotaur
./build-llvm21-freeze/cache-infer -n 128
```

- `Redis.pm` was reinstalled into the local Perl path, so Perl cache tools should work again.

## Current CPU2026 Status

- `intrate` built cleanly.
- `fprate` had build failures in:
  - `722.palm_r`
  - `749.fotonik3d_r`
  - `765.roms_r`
- These are Fortran-heavy benchmarks.
- `749.fotonik3d_r` currently fails at link with `ld.lld: undefined symbol: main`.
- No miscompile evidence has been observed so far, but note:
  - the current SPEC run is extraction-only (`MINOTAUR_NO_INFER=ON`)
  - extraction does not apply synthesized rewrites

## Codebase Notes

- There are local uncommitted changes in the worktree. Read `git status` before editing.
- `lib/interp.cpp` has an unrelated local modification; do not revert it accidentally.
- A short LLVM optimization note exists at:
  - `/localdev/zhengyangliu/minotaur/exact-sdiv-unsigned-compare-report.md`

## Practical Guidance

- If you need fresh cache results, flush Redis before starting a new extraction campaign.
- If you need benchmark opportunity mining during a build, inspect Redis keys directly or use:
  - `./build-llvm21-freeze/cache-dump`
- CPU2026 is surfacing many cuts involving:
  - `select`
  - `shufflevector`
  - `insertelement`
  - `icmp samesign`
  - `llvm.fshl.*`
  - `llvm.vector.reduce.*`

