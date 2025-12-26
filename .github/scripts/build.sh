#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BUILD_DIR="${ROOT_DIR}/build"

: "${CMAKE_BUILD_TYPE:=Release}"

LLVM_SOURCE_DIR_DEFAULT="$HOME/llvm"
LLVM_BUILD_DIR_DEFAULT="$LLVM_SOURCE_DIR_DEFAULT/build"
ALIVE2_SOURCE_DIR_DEFAULT="$HOME/alive2"
ALIVE2_BUILD_DIR_DEFAULT="$ALIVE2_SOURCE_DIR_DEFAULT/build"

LLVM_SOURCE_DIR="${LLVM_SOURCE_DIR:-$LLVM_SOURCE_DIR_DEFAULT}"
LLVM_BUILD_DIR="${LLVM_BUILD_DIR:-$LLVM_BUILD_DIR_DEFAULT}"
ALIVE2_SOURCE_DIR="${ALIVE2_SOURCE_DIR:-$ALIVE2_SOURCE_DIR_DEFAULT}"
ALIVE2_BUILD_DIR="${ALIVE2_BUILD_DIR:-$ALIVE2_BUILD_DIR_DEFAULT}"

JOBS=4
if command -v nproc >/dev/null 2>&1; then
  JOBS="$(nproc)"
elif command -v sysctl >/dev/null 2>&1; then
  JOBS="$(sysctl -n hw.ncpu || echo 4)"
fi

echo "Using ${JOBS} parallel build jobs"
echo "CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
echo "CMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER:-<default>}"

echo "=== Ensuring LLVM is built at ${LLVM_BUILD_DIR} ==="
if [ ! -x "${LLVM_BUILD_DIR}/bin/llvm-config" ] && [ ! -x "${LLVM_BUILD_DIR}/bin/clang" ]; then
  mkdir -p "$(dirname "${LLVM_SOURCE_DIR}")"
  if [ ! -d "${LLVM_SOURCE_DIR}" ]; then
    git clone --depth=1 https://github.com/llvm/llvm-project.git \
      "${LLVM_SOURCE_DIR}"
  fi

  mkdir -p "${LLVM_BUILD_DIR}"
  cd "${LLVM_BUILD_DIR}"
  cmake -G Ninja \
    -DLLVM_ENABLE_RTTI=ON \
    -DLLVM_ENABLE_EH=ON \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DLLVM_ENABLE_PROJECTS="llvm;clang" \
    "${LLVM_SOURCE_DIR}/llvm"
  ninja -j"${JOBS}"
else
  echo "Reusing existing LLVM build at ${LLVM_BUILD_DIR}"
fi

echo "=== Ensuring Alive2 is built at ${ALIVE2_BUILD_DIR} ==="
if [ ! -d "${ALIVE2_SOURCE_DIR}" ]; then
  git clone --depth=1 https://github.com/alivetoolkit/alive2.git \
    "${ALIVE2_SOURCE_DIR}"
fi

cd "${ALIVE2_SOURCE_DIR}"
for patch in \
  "${ROOT_DIR}/alive2-calculate-and-init-constants.patch" \
  "${ROOT_DIR}/alive2-fromfloat-line453.patch"; do
  if [ -f "${patch}" ]; then
    if git apply --check "${patch}" >/dev/null 2>&1; then
      echo "Applying patch $(basename "${patch}")"
      git apply "${patch}"
    else
      echo "Skipping patch $(basename "${patch}") (already applied or not applicable)"
    fi
  fi
done

mkdir -p "${ALIVE2_BUILD_DIR}"
cd "${ALIVE2_BUILD_DIR}"
cmake -G Ninja \
  -DLLVM_DIR="${LLVM_BUILD_DIR}/lib/cmake/llvm" \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DBUILD_TV=1 \
  "${ALIVE2_SOURCE_DIR}"
ninja -j"${JOBS}"

echo "=== Configuring and building Minotaur in ${BUILD_DIR} ==="
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

CMAKE_ARGS=(
  -G Ninja
  -DALIVE2_SOURCE_DIR="${ALIVE2_SOURCE_DIR}"
  -DALIVE2_BUILD_DIR="${ALIVE2_BUILD_DIR}"
  -DCMAKE_PREFIX_PATH="${LLVM_BUILD_DIR}"
  -DCMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE}"
)

if [ "${CMAKE_CXX_COMPILER-}" != "" ]; then
  CMAKE_ARGS+=("-DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}")
fi

if [ "${CMAKE_CXX_FLAGS-}" != "" ]; then
  CMAKE_ARGS+=("-DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}")
fi

cmake "${CMAKE_ARGS[@]}" "${ROOT_DIR}"
ninja -j"${JOBS}"

echo "=== Build completed successfully ==="


