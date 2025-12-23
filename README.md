# Minotaur: a Synthesizing Superoptimizer for LLVM

[![Build](https://github.com/minotaur-toolkit/minotaur/actions/workflows/build.yml/badge.svg)](https://github.com/minotaur-toolkit/minotaur/actions/workflows/build.yml)

A description of how Minotaur works can be found in
https://arxiv.org/abs/2306.00229.

## Build Minotaur using Docker

To build the docker container, use

    docker build -t minotaur-dev -f Dockerfile .

To run the container, use

    docker run -it minotaur-dev bash

## Build Minotaur from source code

Clone the repo with
    git clone git@github.com:minotaur-toolkit/minotaur $HOME/minotaur

Minotaur requires `cmake`, `ninja-build`, `gcc-10`, `g++-10`,
`redis`, `redis-server`, `libhiredis-dev`, `libbsd-resource-perl`,
`libredis-perl`, `libgtest-dev`, and `re2c` as dependencies. On
Ubuntu/Debian, use

    sudo apt-get install cmake ninja-build gcc-10 g++-10 redis redis-server libhiredis-dev libbsd-resource-perl libredis-perl re2c libgtest-dev

or on mac, use

    brew install cmake re2c z3 hiredis redis

to install dependencies.

The Alive2 requires a LLVM compiled with RTTI and exceptions enabled,
use the following command to fetch and build LLVM.

    git clone --depth=1 git@github.com:llvm/llvm-project $HOME/llvm
    cd $HOME/llvm && git apply $HOME/minotaur/llvm-main-minotaur.patch
    mkdir $HOME/llvm/build && cd $HOME/llvm/build
    cmake -GNinja -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_EH=ON -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_ENABLE_PROJECTS="llvm;clang" ../llvm
    ninja

To fetch and build the Alive2, use

    git clone --depth=1 git@github.com:alivetoolkit/alive2.git $HOME/alive2
    cd $HOME/alive2 && git apply $HOME/minotaur/alive2-calculate-and-init-constants.patch && git apply $HOME/minotaur/alive2-fromfloat-line453.patch
    mkdir $HOME/alive2/build && cd $HOME/alive2/build
    cmake -GNinja -DLLVM_DIR=$HOME/llvm/build/lib/cmake/llvm -DBUILD_TV=1 -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
    ninja

To build Minotaur, use

    mkdir $HOME/minotaur/build && cd $HOME/minotaur/build
    cmake .. -DALIVE2_SOURCE_DIR=$HOME/alive2 -DALIVE2_BUILD_DIR=$HOME/alive2/build -DCMAKE_PREFIX_PATH=$HOME/llvm/build -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo -G Ninja
    ninja

To run the test suite, use

    ninja check

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
Users can call `minotaur-cc` or `minotaur-cxx` in the `build`
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

    MINOTAUR_NO_INFER=ON $HOME/llvm/build/bin/opt -load-pass-plugin $HOME/minotaur/build/minotaur.so -passes="minotaur" <LLVM bitcode>

For a single C/C++ source,

    ENABLE_MINOTAUR=ON MINOTAUR_NO_INFER=ON $HOME/minotaur/build/minotaur-cc <c source> [clang options]

For a C/C++ project, simply set CC and CXX to `minotaur-cc` and `minotaur-cxx`, and run `configure` as usual. Set `ENABLE_MINOTAUR` and `MINOTAUR_NO_INFER` to `ON` for `make`.

    CC=$HOME/minotaur/build/minotaur-cc CXX=$HOME/minotaur/build/minotaur-cxx ./configure
    ENABLE_MINOTAUR=ON MINOTAUR_NO_INFER=ON make

#### Run synthesis on cuts

Run the `cache-infer` program to retrieve cuts from the cache and run
synthesis on them.

    $HOME/minotaur/build/cache-infer

After running `cache-infer`, the cache will be populated with the
optimizations that Minotaur discovered. User can run the `opt`,
`minotaur-cc`, `minotaur-cxx` or `make`  again, to compile the program
with the synthesized optimizations.

### Dump synthesized results from cache

To dump synthesized results from cache, use `cache-dump`.

    $HOME/minotaur/build/cache-dump
