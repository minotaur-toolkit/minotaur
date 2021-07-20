# VectorSynth

To build, use the following command.


    $ cmake .. -DALIVE2_SOURCE_DIR=$HOME/alive2 -DALIVE2_BUILD_DIR=$HOME/alive2/build -DLLVM_DIR=~/llvm/build/lib/cmake/llvm -DCMAKE_BUILD_TYPE=Release -G Ninja
    $ ninja

To run enumerative synthesizer, use the folloing command


    $ ~/llvm/build/bin/opt -load vectorsyn/vectorsyn.so -so -S <LLVM bitcode>