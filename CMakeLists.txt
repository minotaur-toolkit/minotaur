project(vectorsyn)

set(SYNTHESIZER_SRC
  "lib/ConstantSynthesis.cpp"
  "lib/EnumerativeSynthesis.cpp"
  "lib/IR.cpp"
  "lib/LLVMGen.cpp"
  "lib/SIMDBinOp.cpp"
  "lib/Slicing.cpp"
)

add_library(synth STATIC ${SYNTHESIZER_SRC})
set(VECTORSYNTH_LIBS_LLVM synth ${ALIVE_LIBS_LLVM})

add_llvm_library(vectorsyn MODULE lib/Pass.cpp)

target_link_libraries(vectorsyn PRIVATE ${VECTORSYNTH_LIBS_LLVM} ${Z3_LIBRARIES}
  $<$<AND:$<CXX_COMPILER_ID:GNU>,$<VERSION_LESS:$<CXX_COMPILER_VERSION>,9.0>>:stdc++fs>)

if(APPLE)
    set_target_properties(vectorsyn PROPERTIES
        LINK_FLAGS "-undefined dynamic_lookup"
    )
endif(APPLE)

configure_file(
  ${PROJECT_SOURCE_DIR}/scripts/opt-synthesis.sh.in
  ${PROJECT_BINARY_DIR}/opt-synthesis-test.sh
  @ONLY
)

add_custom_target("check-vectorsyn"
                  COMMAND "python"
                          "${PROJECT_SOURCE_DIR}/tests/lit/lit.py"
                          "-s"
                          "${PROJECT_SOURCE_DIR}/tests"
                          "-j${TEST_NTHREADS}"
                  DEPENDS "vectorsyn"
                  USES_TERMINAL
                 )