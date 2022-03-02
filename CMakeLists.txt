cmake_minimum_required(VERSION 3.8)
include(ProcessorCount)

project(Minotaur)

if (NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug)
endif()

message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS                "-Wall -march=native -fPIC ${CMAKE_CXX_FLAGS}")
set(CMAKE_CXX_FLAGS_DEBUG          "-g -Og ${CMAKE_CXX_FLAGS_DEBUG}")
set(CMAKE_CXX_FLAGS_RELEASE        "-O3 ${CMAKE_CXX_FLAGS_RELEASE}")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELEASE} -g ${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")

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

include_directories(include)
set(SYNTHESIZER_SRC
  "lib/ConstantSynthesis.cpp"
  "lib/EnumerativeSynthesis.cpp"
  "lib/IR.cpp"
  "lib/LLVMGen.cpp"
  "lib/Type.cpp"
)


find_package(Z3 4.8.5 REQUIRED)

find_path(HIREDIS_INCLUDE_DIR
  NAMES
  hiredis/hiredis.h)

find_library(HIREDIS_LIBRARY
  NAMES
  hiredis)

include_directories(${HIREDIS_INCLUDE_DIR}/hiredis)

llvm_map_components_to_libnames(LLVM_LIBS analysis bitwriter core irreader passes scalaropts support transformutils mc AllTargetsMCAs x86codegen x86desc x86info object x86asmparser)

add_library(machine_cost STATIC "lib/MachineCost.cpp")
target_link_libraries(machine_cost PRIVATE ${LLVM_LIBS})

add_library(utils STATIC "lib/Utils.cpp")
target_link_libraries(utils PRIVATE ${LLVM_LIBS})

add_library(slice STATIC "lib/Slice.cpp")
target_link_libraries(slice PRIVATE utils)

add_library(synthesizer STATIC ${SYNTHESIZER_SRC})
target_link_libraries(synthesizer PRIVATE utils machine_cost)

add_llvm_library(minotaur MODULE pass/online.cpp)
target_link_libraries(minotaur PRIVATE synthesizer ${ALIVE_LIBS} ${Z3_LIBRARIES} ${LLVM_LIBS}
  $<$<AND:$<CXX_COMPILER_ID:GNU>,$<VERSION_LESS:$<CXX_COMPILER_VERSION>,9.0>>:stdc++fs>)

add_llvm_library(cache-exprs MODULE pass/cache-exprs.cpp)
target_link_libraries(cache-exprs PRIVATE slice ${HIREDIS_LIBRARY}
  $<$<AND:$<CXX_COMPILER_ID:GNU>,$<VERSION_LESS:$<CXX_COMPILER_VERSION>,9.0>>:stdc++fs>)

add_llvm_executable(minotaur-cs     "tools/minotaur-cs.cpp")
add_llvm_executable(minotaur-slice  "tools/minotaur-slice.cpp")
add_llvm_executable(bitcode-mca     "tools/bitcode-mca.cpp")
target_link_libraries(minotaur-cs PRIVATE synthesizer ${ALIVE_LIBS} ${LLVM_LIBS} ${Z3_LIBRARIES}
  $<$<AND:$<CXX_COMPILER_ID:GNU>,$<VERSION_LESS:$<CXX_COMPILER_VERSION>,9.0>>:stdc++fs>)
target_link_libraries(minotaur-slice PRIVATE slice ${ALIVE_LIBS} ${HIREDIS_LIBRARY}
  $<$<AND:$<CXX_COMPILER_ID:GNU>,$<VERSION_LESS:$<CXX_COMPILER_VERSION>,9.0>>:stdc++fs>)
target_link_libraries(bitcode-mca PRIVATE machine_cost ${LLVM_LIBS}
  $<$<AND:$<CXX_COMPILER_ID:GNU>,$<VERSION_LESS:$<CXX_COMPILER_VERSION>,9.0>>:stdc++fs>)

if(APPLE)
    set_target_properties(minotaur PROPERTIES
        LINK_FLAGS "-undefined dynamic_lookup"
    )
    set_target_properties(minotaur-cs PROPERTIES
        LINK_FLAGS "-undefined dynamic_lookup"
    )
    set_target_properties(minotaur-slice PROPERTIES
        LINK_FLAGS "-undefined dynamic_lookup"
    )
    set_target_properties(cache-exprs PROPERTIES
        LINK_FLAGS "-undefined dynamic_lookup"
    )
endif(APPLE)

configure_file(
  ${PROJECT_SOURCE_DIR}/scripts/opt-synthesis.sh.in
  ${PROJECT_BINARY_DIR}/opt-synthesis-test.sh
  @ONLY
)

set(CACHE_EXPRS_PASS ${CMAKE_BINARY_DIR}/cache-exprs${CMAKE_SHARED_LIBRARY_SUFFIX})
configure_file(
  ${PROJECT_SOURCE_DIR}/scripts/minotaur-cc.in
  ${PROJECT_BINARY_DIR}/minotaur-cc
  @ONLY
)
configure_file(
  ${PROJECT_SOURCE_DIR}/scripts/minotaur-cc.in
  ${PROJECT_BINARY_DIR}/minotaur-c++
  @ONLY
)
configure_file(
  ${PROJECT_SOURCE_DIR}/scripts/cache-dump.in
  ${PROJECT_BINARY_DIR}/cache-dump
  @ONLY
)
configure_file(
  ${PROJECT_SOURCE_DIR}/scripts/cache-infer.in
  ${PROJECT_BINARY_DIR}/cache-infer
  @ONLY
)
configure_file(
  ${PROJECT_SOURCE_DIR}/scripts/get-cost.in
  ${PROJECT_BINARY_DIR}/get-cost
  @ONLY
)

if (NOT DEFINED TEST_NTHREADS)
  ProcessorCount(TEST_NTHREADS)
  if (TEST_NTHREADS EQUAL 0)
    set(TEST_NTHREADS 1)
  endif()
endif()

add_custom_target("check"
                  COMMAND "python"
                          "${PROJECT_SOURCE_DIR}/tests/lit/lit.py"
                          "-s"
                          "${PROJECT_SOURCE_DIR}/tests"
                          "-j${TEST_NTHREADS}"
                  DEPENDS "minotaur"
                  USES_TERMINAL
                 )