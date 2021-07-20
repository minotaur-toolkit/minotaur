# Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
# Distributed under the MIT license that can be found in the LICENSE file.

if (ALIVE2_SOURCE_DIR)
  message(STATUS "alive2 source directory: ${ALIVE2_SOURCE_DIR}")
else()
  message(SEND_ERROR "Alive2 source directory is not set")
endif()

if (ALIVE2_BUILD_DIR)
  find_library(ALIVE2_IR_LIBS ir PATHS "${ALIVE2_BUILD_DIR}" NO_DEFAULT_PATH)
  find_library(ALIVE2_SMT_LIBS smt PATHS "${ALIVE2_BUILD_DIR}" NO_DEFAULT_PATH)
  find_library(ALIVE2_TOOLS_LIBS tools PATHS "${ALIVE2_BUILD_DIR}" NO_DEFAULT_PATH)
  find_library(ALIVE2_UTIL_LIBS util PATHS "${ALIVE2_BUILD_DIR}" NO_DEFAULT_PATH)

  set(ALIVE_LIBS ${ALIVE2_IR_LIBS} ${ALIVE2_SMT_LIBS} ${ALIVE2_TOOLS_LIBS} ${ALIVE2_UTIL_LIBS})
  message(STATUS "Found alive libs: ${ALIVE_LIBS}")
else()
  message(SEND_ERROR "Alive2 build directory is not set")
endif()
