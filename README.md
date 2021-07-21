# The Minotaur Program Synthesizer

To build Minotaur, use the following command.

    $ cmake .. -DALIVE2_SOURCE_DIR=$HOME/alive2 -DALIVE2_BUILD_DIR=$HOME/alive2/build -DLLVM_DIR=~/llvm/build/lib/cmake/llvm -DCMAKE_BUILD_TYPE=Release -G Ninja
    $ ninja

To run the program synthesizer, use the folloing command

    $ ~/llvm/build/bin/opt -load minotaur.so -so -S <LLVM bitcode>