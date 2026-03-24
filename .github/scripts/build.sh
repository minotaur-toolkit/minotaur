#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BUILD_DIR="${ROOT_DIR}/build"
PINNED_DEPS_FILE="${ROOT_DIR}/pinned-deps.env"

: "${CMAKE_BUILD_TYPE:=Release}"

if [ ! -f "${PINNED_DEPS_FILE}" ]; then
  echo "missing pinned dependency file: ${PINNED_DEPS_FILE}" >&2
  exit 1
fi

# shellcheck disable=SC1090
. "${PINNED_DEPS_FILE}"

: "${MINOTAUR_LLVM_REF:?missing MINOTAUR_LLVM_REF}"
: "${MINOTAUR_ALIVE2_REF:?missing MINOTAUR_ALIVE2_REF}"

Z3_PREFIX="${Z3_PREFIX-}"

LLVM_SOURCE_DIR_DEFAULT="$HOME/llvm"
LLVM_BUILD_DIR_DEFAULT="$LLVM_SOURCE_DIR_DEFAULT/build"
ALIVE2_SOURCE_DIR_DEFAULT="$HOME/alive2"
ALIVE2_BUILD_DIR_DEFAULT="$ALIVE2_SOURCE_DIR_DEFAULT/build"

LLVM_SOURCE_DIR="${LLVM_SOURCE_DIR:-$LLVM_SOURCE_DIR_DEFAULT}"
LLVM_BUILD_DIR="${LLVM_BUILD_DIR:-$LLVM_BUILD_DIR_DEFAULT}"
ALIVE2_SOURCE_DIR="${ALIVE2_SOURCE_DIR:-$ALIVE2_SOURCE_DIR_DEFAULT}"
ALIVE2_BUILD_DIR="${ALIVE2_BUILD_DIR:-$ALIVE2_BUILD_DIR_DEFAULT}"

if [ "${LLVM_TARGETS_TO_BUILD-}" = "" ]; then
  LLVM_TARGETS_TO_BUILD="X86;AArch64;RISCV"
fi

JOBS=4
if command -v nproc >/dev/null 2>&1; then
  JOBS="$(nproc)"
elif command -v sysctl >/dev/null 2>&1; then
  JOBS="$(sysctl -n hw.ncpu || echo 4)"
fi

echo "Using ${JOBS} parallel build jobs"
echo "CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
echo "CMAKE_C_COMPILER=${CMAKE_C_COMPILER}"
echo "CMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}"
echo "LLVM_TARGETS_TO_BUILD=${LLVM_TARGETS_TO_BUILD}"
echo "Z3_PREFIX=${Z3_PREFIX:-<system/default>}"
echo "MINOTAUR_LLVM_REF=${MINOTAUR_LLVM_REF}"
echo "MINOTAUR_ALIVE2_REF=${MINOTAUR_ALIVE2_REF}"

ensure_git_commit_checkout() {
  local url="$1"
  local dir="$2"
  local commit="$3"

  if [ -d "${dir}/.git" ] && \
      [ "$(git -C "${dir}" rev-parse HEAD 2>/dev/null || true)" = "${commit}" ]; then
    echo "Reusing ${dir} at commit ${commit}"
    return
  fi

  rm -rf "${dir}"
  mkdir -p "$(dirname "${dir}")"
  git init "${dir}"
  git -C "${dir}" remote add origin "${url}"
  git -C "${dir}" fetch --depth 1 origin "${commit}"
  git -C "${dir}" checkout --force --detach FETCH_HEAD
}

apply_alive2_local_patches() {
  local patch_file="${ROOT_DIR}/.github/patches/alive2-reset-llvm-utils-cache.patch"
  local utils_cpp="${ALIVE2_SOURCE_DIR}/llvm_util/utils.cpp"

  if [ ! -f "${patch_file}" ]; then
    echo "missing Alive2 patch: ${patch_file}" >&2
    exit 1
  fi

  if grep -q "type_cache.clear();" "${utils_cpp}"; then
    echo "Alive2 cache reset patch already present"
    return
  fi

  echo "Applying Alive2 cache reset patch"
  git -C "${ALIVE2_SOURCE_DIR}" apply --check "${patch_file}"
  git -C "${ALIVE2_SOURCE_DIR}" apply "${patch_file}"
}

llvm_build_matches_targets() {
  local config_file="${LLVM_BUILD_DIR}/lib/cmake/llvm/LLVMConfig.cmake"
  if [ ! -f "${config_file}" ]; then
    return 1
  fi

  local configured_targets
  configured_targets="$(
    sed -n 's/^set(LLVM_TARGETS_TO_BUILD \(.*\))$/\1/p' "${config_file}" \
      | head -n 1
  )"
  [ "${configured_targets}" = "${LLVM_TARGETS_TO_BUILD}" ]
}

echo "=== Ensuring LLVM is built at ${LLVM_BUILD_DIR} ==="
if [ ! -x "${LLVM_BUILD_DIR}/bin/llvm-config" ] || \
   [ ! -x "${LLVM_BUILD_DIR}/bin/clang" ] || \
   ! llvm_build_matches_targets; then
  if [ -d "${LLVM_BUILD_DIR}" ] && ! llvm_build_matches_targets; then
    echo "Rebuilding LLVM because the existing target set does not match LLVM_TARGETS_TO_BUILD=${LLVM_TARGETS_TO_BUILD}"
    rm -rf "${LLVM_BUILD_DIR}"
  fi

  ensure_git_commit_checkout \
    "https://github.com/llvm/llvm-project.git" \
    "${LLVM_SOURCE_DIR}" \
    "${MINOTAUR_LLVM_REF}"

  LLVM_CMAKE_ARGS=(
    -G Ninja
    -DLLVM_ENABLE_RTTI=ON
    -DLLVM_ENABLE_EH=ON
    -DBUILD_SHARED_LIBS=ON
    -DCMAKE_BUILD_TYPE=Release
    -DLLVM_ENABLE_ASSERTIONS=ON
    -DLLVM_ENABLE_PROJECTS="llvm;clang;lld"
    -DLLVM_INCLUDE_TESTS=OFF
    -DLLVM_BUILD_TESTS=OFF
    -DLLVM_INCLUDE_EXAMPLES=OFF
    -DLLVM_INCLUDE_DOCS=OFF
    -DLLVM_ENABLE_TERMINFO=OFF
    -DLLVM_ENABLE_LIBEDIT=OFF
    -DLLVM_ENABLE_LIBXML2=OFF
    -DLLVM_ENABLE_ZLIB=OFF
    -DLLVM_ENABLE_ZSTD=OFF
    -DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS_TO_BUILD}"
    -DCMAKE_C_COMPILER="${CMAKE_C_COMPILER}"
    -DCMAKE_CXX_COMPILER="${CMAKE_CXX_COMPILER}"
  )

  mkdir -p "${LLVM_BUILD_DIR}"
  cd "${LLVM_BUILD_DIR}"
  cmake "${LLVM_CMAKE_ARGS[@]}" "${LLVM_SOURCE_DIR}/llvm"
  ninja -j"${JOBS}"
else
  echo "Reusing existing LLVM build at ${LLVM_BUILD_DIR}"
fi

echo "=== Ensuring Alive2 is built at ${ALIVE2_BUILD_DIR} ==="
ensure_git_commit_checkout \
  "https://github.com/AliveToolkit/alive2.git" \
  "${ALIVE2_SOURCE_DIR}" \
  "${MINOTAUR_ALIVE2_REF}"
apply_alive2_local_patches

mkdir -p "${ALIVE2_BUILD_DIR}"
cd "${ALIVE2_BUILD_DIR}"

ALIVE2_CMAKE_ARGS=(
  -G Ninja
  -DLLVM_DIR="${LLVM_BUILD_DIR}/lib/cmake/llvm"
  -DCMAKE_BUILD_TYPE=RelWithDebInfo
  -DBUILD_TV=1
  -DCMAKE_C_COMPILER="${CMAKE_C_COMPILER}"
  -DCMAKE_CXX_COMPILER="${CMAKE_CXX_COMPILER}"
)

# GCC 14 has false positive -Warray-bounds warnings with std::string
if [[ "${CMAKE_CXX_COMPILER}" == *"g++-14"* ]]; then
  ALIVE2_CMAKE_ARGS+=("-DCMAKE_CXX_FLAGS=-Wno-array-bounds")
fi

if [ "${Z3_PREFIX}" != "" ]; then
  # Help Alive2 find libz3 + headers from a non-system install.
  ALIVE2_CMAKE_ARGS+=("-DCMAKE_PREFIX_PATH=${Z3_PREFIX}")
fi

cmake "${ALIVE2_CMAKE_ARGS[@]}" \
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
  -DCMAKE_C_COMPILER="${CMAKE_C_COMPILER}"
  -DCMAKE_CXX_COMPILER="${CMAKE_CXX_COMPILER}"
)

if [ "${Z3_PREFIX}" != "" ]; then
  # Ensure Minotaur finds the same Z3 we built for CI.
  CMAKE_ARGS+=("-DCMAKE_PREFIX_PATH=${LLVM_BUILD_DIR};${Z3_PREFIX}")
fi

if [ "${CMAKE_CXX_FLAGS-}" != "" ]; then
  CMAKE_ARGS+=("-DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}")
fi

cmake "${CMAKE_ARGS[@]}" "${ROOT_DIR}"
ninja -j"${JOBS}"

echo "=== Build completed successfully ==="
