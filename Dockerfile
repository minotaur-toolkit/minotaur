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
                       libgtest-dev         \
                       libz3-dev

# Create a non-root user and set up permissions
RUN groupadd -r dev && useradd -m -r -g dev -s /bin/bash dev
RUN echo 'dev ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/dev
RUN chmod 0440 /etc/sudoers.d/dev
RUN mkdir -p /workspace && chown dev:dev /workspace

# Switch to non-root user
USER dev

ENV HOME /home/dev
WORKDIR $HOME

# Add the keys and set permissions
RUN mkdir -p /home/dev/.ssh
ARG ssh_prv_key
ARG ssh_pub_key
RUN echo "$ssh_prv_key" > /home/dev/.ssh/id_ed25519 && \
    echo "$ssh_pub_key" > /home/dev/.ssh/id_ed25519.pub && \
    chmod 600 /home/dev/.ssh/id_ed25519 && \
    chmod 644 /home/dev/.ssh/id_ed25519.pub
RUN echo "Host *\n\tStrictHostKeyChecking no\n" > /home/dev/.ssh/config && \
    chmod 644 /home/dev/.ssh/config

RUN git clone --depth=1 -b llvmorg-20.1.8-patched git@github.com:minotaur-toolkit/llvm.git
WORKDIR $HOME/llvm/build
RUN cmake -G Ninja -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_EH=ON   \
      -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo \
      -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_ENABLE_ASSERTIONS=ON  \
      -DLLVM_ENABLE_PROJECTS="llvm;clang" \
      $HOME/llvm/llvm
RUN ninja

# Fetch and build the Alive2 with the semantic for intrinsics
WORKDIR $HOME
RUN git clone --depth=1 -b v20.0 git@github.com:alivetoolkit/alive2.git
COPY alive2-calculate-and-init-constants.patch /tmp/alive2-calculate-and-init-constants.patch
WORKDIR $HOME/alive2
RUN git apply /tmp/alive2-calculate-and-init-constants.patch
WORKDIR $HOME/alive2/build
RUN cmake -G Ninja -DLLVM_DIR=$HOME/llvm/build/lib/cmake/llvm \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_TV=1          \
      $HOME/alive2
RUN ninja

# # To build Minotaur, use the following command.
WORKDIR $HOME
RUN git clone --depth=1 git@github.com:minotaur-toolkit/minotaur.git
WORKDIR $HOME/minotaur/build
RUN cmake -DALIVE2_SOURCE_DIR=$HOME/alive2 \
      -DALIVE2_BUILD_DIR=$HOME/alive2/build \
      -DCMAKE_PREFIX_PATH=$HOME/llvm/build -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo -G Ninja \
       $HOME/minotaur
RUN ninja

CMD ["bash", "-lc", "redis-server --save '' --appendonly no --dir /tmp --daemonize yes && exec bash"]
