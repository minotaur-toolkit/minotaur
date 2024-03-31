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

find_program(RE2C re2c)
if (RE2C)
  message(STATUS "RE2C: ${RE2C}")
else()
  message(SEND_ERROR "re2c executable not found")
endif()
add_custom_command(OUTPUT "${PROJECT_BINARY_DIR}/lexer/lexer.cpp"
                   COMMAND ${CMAKE_COMMAND} -E make_directory "${PROJECT_BINARY_DIR}/lexer"
                   COMMAND ${RE2C} ARGS "-d" "-b" "-T" "--no-generation-date"
                   "-o" "${PROJECT_BINARY_DIR}/lexer/lexer.cpp"
                   "${PROJECT_SOURCE_DIR}/lib/lexer.re"
                   DEPENDS "lib/lexer.re")


find_package(LLVM REQUIRED CONFIG)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(AddLLVM)

include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})


find_package(Git REQUIRED)
add_custom_command(
  OUTPUT "${PROJECT_BINARY_DIR}/minotaur_gen.h.tmp"
  COMMAND "${CMAKE_COMMAND}" -E echo_append "#define MINOTAUR_VERSION_MACRO " > "${PROJECT_BINARY_DIR}/minotaur_gen.h.tmp"
  COMMAND "${GIT_EXECUTABLE}" describe --tags --dirty --always >> "${PROJECT_BINARY_DIR}/minotaur_gen.h.tmp"
  WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
  VERBATIM
)
add_custom_command(
  DEPENDS "${PROJECT_BINARY_DIR}/minotaur_gen.h.tmp"
  OUTPUT "${PROJECT_BINARY_DIR}/minotaur_gen.h"
  COMMAND "${CMAKE_COMMAND}" -E copy_if_different "${PROJECT_BINARY_DIR}/minotaur_gen.h.tmp" "${PROJECT_BINARY_DIR}/minotaur_gen.h"
  COMMAND "${CMAKE_COMMAND}" -E remove -f "${PROJECT_BINARY_DIR}/minotaur_gen.h.tmp"
  WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
  VERBATIM
)
add_custom_target(
  generate_version ALL
  DEPENDS "${PROJECT_BINARY_DIR}/minotaur_gen.h"
  WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
)

include_directories(include)
include_directories(${PROJECT_BINARY_DIR})

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

find_package(Alive2)
include_directories(${ALIVE2_SOURCE_DIR})

set(SYNTHESIZER_SRC
  "lib/alive-interface.cpp"
  "lib/enumerator.cpp"
  "lib/expr.cpp"
  "lib/codegen.cpp"
  "lib/parse.cpp"
  "lib/type.cpp"
  "${PROJECT_BINARY_DIR}/lexer/lexer.cpp"
)

find_package(Z3 4.8.5 REQUIRED)

find_path(HIREDIS_INCLUDE_DIR
  NAMES
  "hiredis/hiredis.h")

find_library(HIREDIS_LIBRARY
  NAMES
  hiredis)

include_directories(${HIREDIS_INCLUDE_DIR}/hiredis)

llvm_map_components_to_libnames(LLVM_LIBS
  analysis core irreader passes scalaropts support transformutils targetparser)

add_library(cost STATIC "lib/cost.cpp"
                        "${PROJECT_BINARY_DIR}/cost-command.h")
target_link_libraries(cost PRIVATE ${LLVM_LIBS})

add_library(utils STATIC "lib/utils.cpp")
target_link_libraries(utils PRIVATE ${LLVM_LIBS} ${HIREDIS_LIBRARY})

add_library(config STATIC "lib/config.cpp"
                         "${PROJECT_BINARY_DIR}/minotaur_gen.h")
add_dependencies(config generate_version)

add_library(slice STATIC "lib/slice.cpp")
target_link_libraries(slice PRIVATE utils config)

add_library(synthesizer STATIC ${SYNTHESIZER_SRC})
target_link_libraries(synthesizer PRIVATE utils cost config)

add_llvm_library(online MODULE "pass/online.cpp")

target_link_libraries(online
  PRIVATE synthesizer slice ${ALIVE_LIBS} ${Z3_LIBRARIES} ${LLVM_LIBS}
  $<$<AND:$<CXX_COMPILER_ID:GNU>,$<VERSION_LESS:$<CXX_COMPILER_VERSION>,9.0>>:stdc++fs>)


add_llvm_executable(minotaur-cs "tools/minotaur-cs.cpp")

target_link_libraries(minotaur-cs
  PRIVATE synthesizer ${ALIVE_LIBS} ${LLVM_LIBS} ${Z3_LIBRARIES}
  $<$<AND:$<CXX_COMPILER_ID:GNU>,$<VERSION_LESS:$<CXX_COMPILER_VERSION>,9.0>>:stdc++fs>)

add_llvm_executable(minotaur-slice "tools/minotaur-slice.cpp")

target_link_libraries(minotaur-slice
  PRIVATE slice ${ALIVE_LIBS}
  $<$<AND:$<CXX_COMPILER_ID:GNU>,$<VERSION_LESS:$<CXX_COMPILER_VERSION>,9.0>>:stdc++fs>)

add_llvm_executable(parse-tests "unit-tests/parse-tests.cpp")
set(GTEST_LIBS "-lgtest_main -lgtest -lpthread")
target_link_libraries(parse-tests
  PRIVATE synthesizer ${GTEST_LIBS} ${Z3_LIBRARIES}
  $<$<AND:$<CXX_COMPILER_ID:GNU>,$<VERSION_LESS:$<CXX_COMPILER_VERSION>,9.0>>:stdc++fs>)

if(APPLE)
    set_target_properties(online PROPERTIES
        LINK_FLAGS "-undefined dynamic_lookup"
    )
    set_target_properties(minotaur-cs PROPERTIES
        LINK_FLAGS "-undefined dynamic_lookup"
    )
    set_target_properties(minotaur-slice PROPERTIES
        LINK_FLAGS "-undefined dynamic_lookup"
    )
endif(APPLE)

set(ONLINE_PASS ${CMAKE_BINARY_DIR}/online${CMAKE_SHARED_LIBRARY_SUFFIX})

configure_file(
  "${PROJECT_SOURCE_DIR}/include/cost-command.h.in"
  "${PROJECT_BINARY_DIR}/cost-command.h"
  @ONLY
)
configure_file(
  "${PROJECT_SOURCE_DIR}/scripts/opt-minotaur.sh.in"
  "${PROJECT_BINARY_DIR}/opt-minotaur.sh"
  @ONLY
)
configure_file(
  "${PROJECT_SOURCE_DIR}/scripts/infer-cut.sh.in"
  "${PROJECT_BINARY_DIR}/infer-cut.sh"
  @ONLY
)
configure_file(
  "${PROJECT_SOURCE_DIR}/scripts/slice-cc.in"
  "${PROJECT_BINARY_DIR}/slice-cc"
  @ONLY
)
configure_file(
  "${PROJECT_SOURCE_DIR}/scripts/slice-cc.in"
  "${PROJECT_BINARY_DIR}/slice-c++"
  @ONLY
)
configure_file(
  "${PROJECT_SOURCE_DIR}/scripts/minotaur-cc.in"
  "${PROJECT_BINARY_DIR}/minotaur-cc"
  @ONLY
)
configure_file(
  "${PROJECT_SOURCE_DIR}/scripts/minotaur-cc.in"
  "${PROJECT_BINARY_DIR}/minotaur-c++"
  @ONLY
)
configure_file(
  "${PROJECT_SOURCE_DIR}/scripts/cache-dump.in"
  "${PROJECT_BINARY_DIR}/cache-dump"
  @ONLY
)
configure_file(
  "${PROJECT_SOURCE_DIR}/scripts/cache-infer.in"
  "${PROJECT_BINARY_DIR}/cache-infer"
  @ONLY
)
configure_file(
  "${PROJECT_SOURCE_DIR}/scripts/get-cost.in"
  "${PROJECT_BINARY_DIR}/get-cost"
  @ONLY
)

if (NOT DEFINED TEST_NTHREADS)
  ProcessorCount(TEST_NTHREADS)
  if (TEST_NTHREADS EQUAL 0)
    set(TEST_NTHREADS 1)
  endif()
endif()

add_custom_target("check"
                  COMMAND "python3"
                          "${PROJECT_SOURCE_DIR}/tests/lit/lit.py"
                          "-s"
                          "${PROJECT_SOURCE_DIR}/tests"
                          "-j${TEST_NTHREADS}"
                  DEPENDS "online"
                  USES_TERMINAL
)
