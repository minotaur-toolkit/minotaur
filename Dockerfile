FROM ubuntu:24.04

COPY pinned-deps.env /tmp/pinned-deps.env
COPY .github/patches/alive2-reset-llvm-utils-cache.patch /tmp/alive2-reset-llvm-utils-cache.patch

# Install base and project-specific dependencies in a single layer.
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      build-essential \
      cmake \
      git \
      libgtest-dev \
      libhiredis-dev \
      libbsd-resource-perl \
      libredis-perl \
      ninja-build \
      python3 \
      re2c \
      redis-server \
      sudo \
    && rm -rf /var/lib/apt/lists/*

# Build and install Z3 from source at the pinned revision.
RUN . /tmp/pinned-deps.env && \
    git clone --depth 1 --branch "${MINOTAUR_Z3_REF}" \
      https://github.com/Z3Prover/z3.git /tmp/z3 && \
    cmake -S /tmp/z3 -B /tmp/z3/build -G Ninja \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DZ3_BUILD_TEST_EXECUTABLES=OFF \
      -DZ3_BUILD_EXECUTABLE=OFF && \
    cmake --build /tmp/z3/build --target install && \
    rm -rf /tmp/z3

# Create a non-root user.
RUN groupadd -r dev && useradd -m -r -g dev -s /bin/bash dev && \
    echo 'dev ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/dev && \
    chmod 0440 /etc/sudoers.d/dev && \
    mkdir -p /workspace && chown dev:dev /workspace

USER dev
ENV HOME=/home/dev
WORKDIR $HOME

# Build LLVM with RTTI and EH enabled (required by Alive2).
RUN . /tmp/pinned-deps.env && \
    git init "$HOME/llvm" && \
    git -C "$HOME/llvm" remote add origin https://github.com/llvm/llvm-project.git && \
    git -C "$HOME/llvm" fetch --depth 1 origin "${MINOTAUR_LLVM_REF}" && \
    git -C "$HOME/llvm" checkout --force --detach FETCH_HEAD
RUN cmake -G Ninja -B $HOME/llvm/build \
      -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_EH=ON \
      -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release \
      -DLLVM_TARGETS_TO_BUILD="X86;AArch64;RISCV" \
      -DLLVM_ENABLE_ASSERTIONS=ON \
      -DLLVM_ENABLE_PROJECTS="llvm;clang;lld" \
      -DLLVM_INCLUDE_TESTS=OFF \
      -DLLVM_BUILD_TESTS=OFF \
      -DLLVM_INCLUDE_EXAMPLES=OFF \
      -DLLVM_INCLUDE_DOCS=OFF \
      -DLLVM_ENABLE_TERMINFO=OFF \
      -DLLVM_ENABLE_LIBEDIT=OFF \
      -DLLVM_ENABLE_LIBXML2=OFF \
      -DLLVM_ENABLE_ZLIB=OFF \
      -DLLVM_ENABLE_ZSTD=OFF \
      $HOME/llvm/llvm && \
    ninja -C $HOME/llvm/build

# Build Alive2 from the pinned commit.
RUN . /tmp/pinned-deps.env && \
    git init "$HOME/alive2" && \
    git -C "$HOME/alive2" remote add origin https://github.com/AliveToolkit/alive2.git && \
    git -C "$HOME/alive2" fetch --depth 1 origin "${MINOTAUR_ALIVE2_REF}" && \
    git -C "$HOME/alive2" checkout --force --detach FETCH_HEAD && \
    git -C "$HOME/alive2" apply /tmp/alive2-reset-llvm-utils-cache.patch && \
    cmake -G Ninja -B $HOME/alive2/build \
      -DLLVM_DIR=$HOME/llvm/build/lib/cmake/llvm \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_TV=1 \
      $HOME/alive2 && \
    ninja -C $HOME/alive2/build

# Build Minotaur from the checked-out source tree.
COPY --chown=dev:dev . $HOME/minotaur
RUN cmake -G Ninja -S $HOME/minotaur -B $HOME/minotaur-docker-build \
      -DALIVE2_SOURCE_DIR=$HOME/alive2 \
      -DALIVE2_BUILD_DIR=$HOME/alive2/build \
      -DCMAKE_PREFIX_PATH=$HOME/llvm/build \
      -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    && \
    ninja -C $HOME/minotaur-docker-build

ENV PATH=/home/dev/minotaur-docker-build:/home/dev/alive2/build:/home/dev/llvm/build/bin:${PATH}

CMD ["bash", "-lc", \
     "redis-server --save '' --appendonly no --dir /tmp --daemonize yes && exec bash"]
