FROM ubuntu:24.04

# Install base and project-specific dependencies in a single layer.
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
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

# Build and install Z3 from source (pinned tag).
ARG Z3_TAG=z3-4.15.4
RUN git clone --depth 1 --branch ${Z3_TAG} \
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
COPY llvm-main-minotaur.patch /tmp/llvm-main-minotaur.patch
RUN git clone --depth=1 \
      https://github.com/llvm/llvm-project.git $HOME/llvm && \
    cd $HOME/llvm && \
    git apply /tmp/llvm-main-minotaur.patch
RUN cmake -G Ninja -B $HOME/llvm/build \
      -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_EH=ON \
      -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release \
      -DLLVM_TARGETS_TO_BUILD=X86 \
      -DLLVM_ENABLE_ASSERTIONS=ON \
      -DLLVM_ENABLE_PROJECTS="llvm;clang" \
      $HOME/llvm/llvm && \
    ninja -C $HOME/llvm/build

# Build Alive2.
RUN git clone --depth=1 \
      https://github.com/alivetoolkit/alive2.git $HOME/alive2 && \
    cmake -G Ninja -B $HOME/alive2/build \
      -DLLVM_DIR=$HOME/llvm/build/lib/cmake/llvm \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_TV=1 \
      $HOME/alive2 && \
    ninja -C $HOME/alive2/build

# Build Minotaur.
RUN git clone --depth=1 \
      https://github.com/minotaur-toolkit/minotaur.git \
      $HOME/minotaur && \
    cmake -G Ninja -B $HOME/minotaur/build \
      -DALIVE2_SOURCE_DIR=$HOME/alive2 \
      -DALIVE2_BUILD_DIR=$HOME/alive2/build \
      -DCMAKE_PREFIX_PATH=$HOME/llvm/build \
      -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo \
      $HOME/minotaur && \
    ninja -C $HOME/minotaur/build

CMD ["bash", "-lc", \
     "redis-server --save '' --appendonly no --dir /tmp --daemonize yes && exec bash"]
