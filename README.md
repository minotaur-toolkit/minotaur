# Minotaur: a Synthesizing Superoptimizer for LLVM

[![Build](https://github.com/minotaur-toolkit/minotaur/actions/workflows/build.yml/badge.svg)](https://github.com/minotaur-toolkit/minotaur/actions/workflows/build.yml)

A description of how Minotaur works can be found in
https://arxiv.org/abs/2306.00229.

## Build Minotaur using Docker

The Docker build uses the current checkout for Minotaur and the frozen
external revisions from [`pinned-deps.env`](./pinned-deps.env):

- LLVM: commit `292dc2b86f66e39f4b85ec8b185fd8b60f5213ce`
  (upstream release `llvmorg-21.1.7`)
- Alive2: commit `f9ad3cb48a926f456b79e22e73b91cff03fc7b81`
  (newest upstream commit validated against LLVM `21.1.7` as of 2026-03-16)
- Z3: tag `z3-4.15.4`

To build the Docker container, use

    docker build -t minotaur-dev -f Dockerfile .

The Docker build context is the full checkout. Build from a clean clone, or a
copy without large benchmark/build artifacts, if your working tree contains
directories like `build-*`, `cpu2017/`, or `cpu2026/`.

To run the container, use

    docker run -it minotaur-dev bash

## Build Minotaur from source code

Minotaur freezes its external dependency revisions in
[`pinned-deps.env`](./pinned-deps.env). CI, Docker, and
`.github/scripts/build.sh` all use that file, so local builds should use the
same refs.

Minotaur requires `cmake`, `ninja-build`, `gcc-10`, `g++-10`,
`redis`, `redis-server`, `libhiredis-dev`, `libbsd-resource-perl`,
`libredis-perl`, `libgtest-dev` and `re2c` as dependencies. Minotaur/Alive2
also require Z3. On Ubuntu/Debian, use

    sudo apt-get install cmake ninja-build gcc-10 g++-10 redis redis-server libhiredis-dev libbsd-resource-perl libredis-perl re2c libgtest-dev

or on mac, use

    brew install cmake re2c hiredis redis

to install dependencies.

Clone Minotaur first so the pinned dependency file is available.

    git clone https://github.com/minotaur-toolkit/minotaur $HOME/minotaur

Build and install Z3 from source at the pinned ref.

    . $HOME/minotaur/pinned-deps.env
    git clone --depth 1 --branch "$MINOTAUR_Z3_REF" https://github.com/Z3Prover/z3.git $HOME/z3
    cmake -S $HOME/z3 -B $HOME/z3/build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME/z3/install -DZ3_BUILD_TEST_EXECUTABLES=OFF -DZ3_BUILD_EXECUTABLE=ON
    cmake --build $HOME/z3/build --target install

The recommended build path is the same scripted flow used by CI. It fetches
LLVM and Alive2 at the pinned revisions from `pinned-deps.env`.

On Linux, for example:

    export CMAKE_C_COMPILER=gcc-10
    export CMAKE_CXX_COMPILER=g++-10
    Z3_PREFIX=$HOME/z3/install bash $HOME/minotaur/.github/scripts/build.sh

By default, the scripted build requests LLVM backends for `X86`, `AArch64`,
and `RISCV`. Set `LLVM_TARGETS_TO_BUILD` yourself only if you intentionally
want a narrower LLVM build.

If you prefer the manual equivalent, Alive2 requires LLVM built with RTTI and
exceptions enabled. Fetch and build LLVM from the exact pinned commit behind
`llvmorg-21.1.7`:

    . $HOME/minotaur/pinned-deps.env
    git init $HOME/llvm
    git -C $HOME/llvm remote add origin https://github.com/llvm/llvm-project.git
    git -C $HOME/llvm fetch --depth 1 origin "$MINOTAUR_LLVM_REF"
    git -C $HOME/llvm checkout --force --detach FETCH_HEAD
    cmake -GNinja -S $HOME/llvm/llvm -B $HOME/llvm/build -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_EH=ON -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLLVM_TARGETS_TO_BUILD="X86;AArch64;RISCV" -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_ENABLE_PROJECTS="llvm;clang;lld"
    ninja -C $HOME/llvm/build

Fetch and build Alive2 from the pinned commit:

    . $HOME/minotaur/pinned-deps.env
    git init $HOME/alive2
    git -C $HOME/alive2 remote add origin https://github.com/AliveToolkit/alive2.git
    git -C $HOME/alive2 fetch --depth 1 origin "$MINOTAUR_ALIVE2_REF"
    git -C $HOME/alive2 checkout --force --detach FETCH_HEAD
    cmake -GNinja -S $HOME/alive2 -B $HOME/alive2/build -DLLVM_DIR=$HOME/llvm/build/lib/cmake/llvm -DBUILD_TV=1 -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_PREFIX_PATH=$HOME/z3/install
    ninja -C $HOME/alive2/build

To build Minotaur, use

    cmake -S $HOME/minotaur -B $HOME/minotaur/build -DALIVE2_SOURCE_DIR=$HOME/alive2 -DALIVE2_BUILD_DIR=$HOME/alive2/build -DCMAKE_PREFIX_PATH="$HOME/llvm/build;$HOME/z3/install" -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo -G Ninja
    ninja -C $HOME/minotaur/build

To run the test suite, use

    ninja -C $HOME/minotaur/build check

## Use Minotaur

Minotaur can be invoked in two ways, it can be invoked online (during
compilation), but also offline, in a mode where Minotaur extracts cuts
into the redis cache but does not perform synthesis. In offline mode,
a separate program called `cache-infer` retrieves cuts from the cache,
runs synthesis on them, and stores any optimizations that it discovers
back into the cache. Unlike the online mode, which runs synthesis
tasks one after the other, offline mode can run all synthesis jobs in
parallel.


### Online mode

To run the Minotaur on llvm IR files in online mode, use the following
command

    $HOME/llvm/build/bin/opt -load-pass-plugin $HOME/minotaur/build/online.so -passes="minotaur" <LLVM bitcode>

For C/C++ programs, we have a drop-in replacement of C/C++ compiler.
Users can call `minotaur-cc` or `minotaur-c++` in the `build`
directory to compile C/C++ programs. Minotaur pass is disabled by
default; the pass can be enabled by setting environment variable
`ENABLE_MINOTAUR`.

    export ENABLE_MINOTAUR=ON
    $HOME/minotaur/build/minotaur-cc <c source> [clang options]

### Offline mode

#### Extract cuts from source

To extract cuts, one can just set the environment variable
`MINOTAUR_NO_INFER` and run the same command as above.

For a single LLVM IR source,

    MINOTAUR_NO_INFER=ON $HOME/llvm/build/bin/opt -load-pass-plugin $HOME/minotaur/build/online.so -passes="minotaur" <LLVM bitcode>

For a single C/C++ source,

    ENABLE_MINOTAUR=ON MINOTAUR_NO_INFER=ON $HOME/minotaur/build/minotaur-cc <c source> [clang options]

For a C/C++ project, simply set CC and CXX to `minotaur-cc` and `minotaur-c++`, and run `configure` as usual. Set `ENABLE_MINOTAUR` and `MINOTAUR_NO_INFER` to `ON` for `make`.

    CC=$HOME/minotaur/build/minotaur-cc CXX=$HOME/minotaur/build/minotaur-c++ ./configure
    ENABLE_MINOTAUR=ON MINOTAUR_NO_INFER=ON make

#### Run synthesis on cuts

Run the `cache-infer` program to retrieve cuts from the cache and run
synthesis on them.

    $HOME/minotaur/build/cache-infer

After running `cache-infer`, the cache will be populated with the
optimizations that Minotaur discovered. User can run the `opt`,
`minotaur-cc`, `minotaur-c++` or `make`  again, to compile the program
with the synthesized optimizations.

### Dump synthesized results from cache

To dump synthesized results from cache, use `cache-dump`.

    $HOME/minotaur/build/cache-dump
