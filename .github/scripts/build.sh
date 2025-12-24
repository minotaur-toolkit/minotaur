#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BUILD_DIR="${ROOT_DIR}/build"

: "${CMAKE_BUILD_TYPE:=Release}"

# Default locations for dependencies.
LLVM_SOURCE_DIR_DEFAULT="$HOME/llvm"
LLVM_BUILD_DIR_DEFAULT="$LLVM_SOURCE_DIR_DEFAULT/build"
ALIVE2_SOURCE_DIR_DEFAULT="$HOME/alive2"
ALIVE2_BUILD_DIR_DEFAULT="$ALIVE2_SOURCE_DIR_DEFAULT/build"

LLVM_SOURCE_DIR="${LLVM_SOURCE_DIR:-$LLVM_SOURCE_DIR_DEFAULT}"
LLVM_BUILD_DIR="${LLVM_BUILD_DIR:-$LLVM_BUILD_DIR_DEFAULT}"
ALIVE2_SOURCE_DIR="${ALIVE2_SOURCE_DIR:-$ALIVE2_SOURCE_DIR_DEFAULT}"
ALIVE2_BUILD_DIR="${ALIVE2_BUILD_DIR:-$ALIVE2_BUILD_DIR_DEFAULT}"

# Configuration for downloading a prebuilt LLVM toolchain instead of building it.
# These can be overridden via environment variables if needed.
# Default to LLVM 21.1.8 using the official prebuilt archives:
#   - Linux: LLVM-21.1.8-Linux-X64.tar.xz
#   - macOS: LLVM-21.1.8-macOS-ARM64.tar.xz
LLVM_VERSION="${LLVM_VERSION:-21.1.8}"

UNAME_S="$(uname -s)"
case "${UNAME_S}" in
  Darwin)
    LLVM_PLATFORM_DEFAULT="macOS-ARM64"
    LLVM_TARBALL_DEFAULT="LLVM-${LLVM_VERSION}-macOS-ARM64.tar.xz"
    ;;
  Linux)
    LLVM_PLATFORM_DEFAULT="Linux-X64"
    LLVM_TARBALL_DEFAULT="LLVM-${LLVM_VERSION}-Linux-X64.tar.xz"
    ;;
  *)
    echo "Unsupported OS for automatic LLVM download: ${UNAME_S}" >&2
    echo "Please set LLVM_DOWNLOAD_URL to a suitable archive." >&2
    LLVM_PLATFORM_DEFAULT="unknown"
    LLVM_TARBALL_DEFAULT=""
    ;;
esac

LLVM_PLATFORM="${LLVM_PLATFORM:-$LLVM_PLATFORM_DEFAULT}"
LLVM_TARBALL="${LLVM_TARBALL:-$LLVM_TARBALL_DEFAULT}"
LLVM_DOWNLOAD_URL_DEFAULT="https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/${LLVM_TARBALL}"
LLVM_DOWNLOAD_URL="${LLVM_DOWNLOAD_URL:-$LLVM_DOWNLOAD_URL_DEFAULT}"

JOBS=4
if command -v nproc >/dev/null 2>&1; then
  JOBS="$(nproc)"
elif command -v sysctl >/dev/null 2>&1; then
  JOBS="$(sysctl -n hw.ncpu || echo 4)"
fi

echo "Using ${JOBS} parallel build jobs"
echo "CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
echo "CMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER:-<default>}"
echo "LLVM_VERSION=${LLVM_VERSION}"
echo "LLVM_PLATFORM=${LLVM_PLATFORM}"
echo "LLVM_DOWNLOAD_URL=${LLVM_DOWNLOAD_URL}"

echo "=== Ensuring LLVM is available at ${LLVM_BUILD_DIR} ==="
if [ ! -x "${LLVM_BUILD_DIR}/bin/llvm-config" ] && [ ! -x "${LLVM_BUILD_DIR}/bin/clang" ]; then
  echo "LLVM not found; downloading prebuilt LLVM from:"
  echo "  ${LLVM_DOWNLOAD_URL}"

  mkdir -p "${LLVM_BUILD_DIR}"

  if [ -z "${LLVM_TARBALL}" ]; then
    echo "Error: LLVM_TARBALL is empty; cannot determine archive name." >&2
    exit 1
  fi

  TARBALL_PATH="$(mktemp /tmp/llvm-XXXXXX.tar.xz)"
  if command -v curl >/dev/null 2>&1; then
    curl -L "${LLVM_DOWNLOAD_URL}" -o "${TARBALL_PATH}"
  elif command -v wget >/dev/null 2>&1; then
    wget -O "${TARBALL_PATH}" "${LLVM_DOWNLOAD_URL}"
  else
    echo "Error: neither curl nor wget is available to download LLVM." >&2
    exit 1
  fi

  echo "Extracting LLVM into ${LLVM_BUILD_DIR}"
  tar -xJf "${TARBALL_PATH}" --strip-components=1 -C "${LLVM_BUILD_DIR}"
  rm -f "${TARBALL_PATH}"
else
  echo "Reusing existing LLVM installation at ${LLVM_BUILD_DIR}"
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
  -DCMAKE_EXPORT_COMPILE_COMMANDS=1
  "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
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


