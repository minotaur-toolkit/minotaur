FROM ubuntu:24.04

# We install some useful packages.
RUN apt-get update -qq
# Setup base dependencies:
RUN apt-get install -y vim-tiny            \
                       sudo                \
                       python3             \
                       build-essential     \
                       git

# Setup project-specific dependencies:
RUN apt-get -y install cmake                \
                       ninja-build          \
                       redis                \
                       redis-server         \
                       libhiredis-dev       \
                       libbsd-resource-perl \
                       libredis-perl        \
                       re2c                 \
                       libgtest-dev

# Build and install Z3 from source (pinned tag)
ARG Z3_TAG=z3-4.15.4
RUN git clone --depth 1 --branch ${Z3_TAG} https://github.com/Z3Prover/z3.git /tmp/z3 && \
    cmake -S /tmp/z3 -B /tmp/z3/build -G Ninja \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DZ3_BUILD_TEST_EXECUTABLES=OFF \
      -DZ3_BUILD_EXECUTABLE=OFF && \
    cmake --build /tmp/z3/build --target install && \
    rm -rf /tmp/z3

# Create a non-root user and set up permissions
RUN groupadd -r dev && useradd -m -r -g dev -s /bin/bash dev
RUN echo 'dev ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/dev
RUN chmod 0440 /etc/sudoers.d/dev
RUN mkdir -p /workspace && chown dev:dev /workspace

# Switch to non-root user
USER dev

ENV HOME /home/dev
WORKDIR $HOME

# # Add the keys and set permissions
# RUN mkdir -p /home/dev/.ssh
# ARG ssh_prv_key
# ARG ssh_pub_key
# RUN echo "$ssh_prv_key" > /home/dev/.ssh/id_ed25519 && \
#     echo "$ssh_pub_key" > /home/dev/.ssh/id_ed25519.pub && \
#     chmod 600 /home/dev/.ssh/id_ed25519 && \
#     chmod 644 /home/dev/.ssh/id_ed25519.pub
# RUN echo "Host *\n\tStrictHostKeyChecking no\n" > /home/dev/.ssh/config && \
#     chmod 644 /home/dev/.ssh/config

COPY llvm-main-minotaur.patch /tmp/llvm-main-minotaur.patch
RUN git clone --depth=1 https://github.com/llvm/llvm-project.git $HOME/llvm
WORKDIR $HOME/llvm
RUN git apply /tmp/llvm-main-minotaur.patch
WORKDIR $HOME/llvm/build
RUN cmake -G Ninja -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_EH=ON   \
      -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release \
      -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_ENABLE_ASSERTIONS=ON  \
      -DLLVM_ENABLE_PROJECTS="llvm;clang" \
      $HOME/llvm/llvm
RUN ninja

# Fetch and build the Alive2 with the semantic for intrinsics
WORKDIR $HOME
RUN git clone --depth=1 https://github.com/alivetoolkit/alive2.git
WORKDIR $HOME/alive2/build
RUN cmake -G Ninja -DLLVM_DIR=$HOME/llvm/build/lib/cmake/llvm \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_TV=1          \
      $HOME/alive2
RUN ninja

# # To build Minotaur, use the following command.
WORKDIR $HOME
RUN git clone --depth=1 https://github.com/minotaur-toolkit/minotaur.git
WORKDIR $HOME/minotaur/build
RUN cmake -DALIVE2_SOURCE_DIR=$HOME/alive2 \
      -DALIVE2_BUILD_DIR=$HOME/alive2/build \
      -DCMAKE_PREFIX_PATH=$HOME/llvm/build -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo -G Ninja \
       $HOME/minotaur
RUN ninja

CMD ["bash", "-lc", "redis-server --save '' --appendonly no --dir /tmp --daemonize yes && exec bash"]
