# Minotaur: A SIMD-Oriented Synthesizing Superoptimizer

A description of how Minotaur works can be found in https://arxiv.org/abs/2306.00229.

## Build Minotaur using Docker

To build the docker container use:

    docker build -t minotaur-dev -f Dockerfile .

To run the container use:

    docker run -it minotaur-dev bash

## Build Minotaur from source code

The project requires `cmake`, `ninja-build`, `gcc-10`, `g++-10`, `redis`, `redis-server`, `libhiredis-dev`, `libbsd-resource-perl`, `libredis-perl`, `libgtest-dev`, and `re2c` as dependencies. On Ubuntu/Debian, use

    sudo apt-get install cmake ninja-build gcc-10 g++-10 redis redis-server libhiredis-dev libbsd-resource-perl libredis-perl re2c libgtest-dev

or on mac, use

    brew install re2c z3 hiredis redis

to install dependencies.

The Alive2 requires a LLVM compiled with RTTI and exceptions enabled, use the following command to fetch and build LLVM.

    git clone git@github.com:zhengyang92/llvm $HOME/llvm
    mkdir $HOME/llvm/build && cd $HOME/llvm/build
    cmake -GNinja -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_EH=ON -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_ENABLE_PROJECTS="llvm;clang" ../llvm
    ninja

To fetch and build the Alive2 with X86 intrinsics, use the following command.

    git clone git@github.com:minotaur-toolkit/alive2-x86 $HOME/alive2-x86
    mkdir $HOME/alive2-x86/build && cd $HOME/alive2-x86/build
    cmake -GNinja -DLLVM_DIR=$HOME/llvm/build/lib/cmake/llvm -DBUILD_TV=1 -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
    ninja

To build Minotaur, use the following command.

    git clone git@github.com:minotaur-toolkit/minotaur $HOME/minotaur
    mkdir $HOME/minotaur/build && cd $HOME/minotaur/build
    cmake .. -DALIVE2_SOURCE_DIR=$HOME/alive2-x86 -DALIVE2_BUILD_DIR=$HOME/alive2-x86/build -DCMAKE_PREFIX_PATH=$HOME/llvm/build -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo -G Ninja
    ninja

To run the test suite, use

    ninja check

To run the program synthesizer on llvm IR files, use the following command

    $HOME/llvm/build/bin/opt -load-pass-plugin $HOME/minotaur/build/minotaur.so -passes="minotaur-online" <LLVM bitcode>

For C/C++ programs, we have a drop-in replacement of C/C++ compiler. Users can call `minotaur-cc` or `minotaur-cxx` in the `build` directory to compile C/C++ programs. Minotaur pass is disabled by default; the pass can be enabled by setting environment variable `ENABLE_MINOTAUR`.

    $HOME/minotaur/build/minotaur-cc <c source> [clang options]
