cmake_minimum_required(VERSION 3.8)
include(ProcessorCount)

project(Minitaur)

if (NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug)
endif()

message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(LLVM REQUIRED CONFIG)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(AddLLVM)

include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")
find_package(Alive2)
include_directories(${ALIVE2_SOURCE_DIR})

set(SYNTHESIZER_SRC
  "lib/ConstantSynthesis.cpp"
  "lib/EnumerativeSynthesis.cpp"
  "lib/IR.cpp"
  "lib/LLVMGen.cpp"
  "lib/SIMDBinOp.cpp"
  "lib/Slicing.cpp"
)

add_library(synth STATIC ${SYNTHESIZER_SRC})
set(MINOTAUR_LIBS_LLVM synth ${ALIVE_LIBS_LLVM})

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

if (NOT DEFINED TEST_NTHREADS)
  ProcessorCount(TEST_NTHREADS)
  if (TEST_NTHREADS EQUAL 0)
    set(TEST_NTHREADS 1)
  endif()
endif()

add_custom_target("check-vectorsyn"
                  COMMAND "python"
                          "${PROJECT_SOURCE_DIR}/tests/lit/lit.py"
                          "-s"
                          "${PROJECT_SOURCE_DIR}/tests"
                          "-j${TEST_NTHREADS}"
                  DEPENDS "vectorsyn"
                  USES_TERMINAL
                 )