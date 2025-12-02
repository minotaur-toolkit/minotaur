{
  description = "Minotaur: a Synthesizing Superoptimizer for LLVM";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Patched LLVM from minotaur-toolkit with RTTI and exceptions enabled
        llvm-patched-src = pkgs.fetchFromGitHub {
          owner = "minotaur-toolkit";
          repo = "llvm";
          rev = "llvmorg-20.1.8-patched";
          hash = "sha256-tpAJfZkDbxP7sPAyb5T3dkT4OD9DiluQ50R2um6QhM8=";
        };
        
        # Patched LLVM from minotaur-toolkit with RTTI and exceptions enabled
        # Built exactly as in the Dockerfile
        llvm-custom = pkgs.stdenv.mkDerivation {
          pname = "llvm";
          version = "20.1.8-patched";
          
          src = llvm-patched-src;
          sourceRoot = "source/llvm";
          
          nativeBuildInputs = with pkgs; [
            cmake
            ninja
            python3
          ];
          
          buildInputs = with pkgs; [
            libxml2
            libffi
            zlib
          ];
          
          # Match Dockerfile exactly
          cmakeFlags = [
            "-DLLVM_ENABLE_RTTI=ON"
            "-DLLVM_ENABLE_EH=ON"
            "-DBUILD_SHARED_LIBS=ON"
            "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
            "-DLLVM_TARGETS_TO_BUILD=X86"
            "-DLLVM_ENABLE_ASSERTIONS=ON"
            "-DLLVM_ENABLE_PROJECTS=llvm;clang"
            "-DLLVM_INSTALL_UTILS=ON"
          ];
          
          doCheck = false;
          
          meta = with pkgs.lib; {
            description = "Patched LLVM for Minotaur";
            homepage = "https://github.com/minotaur-toolkit/llvm";
          };
        };
        
        # Alive2 with intrinsics support
        alive2-intrinsics = pkgs.stdenv.mkDerivation {
          pname = "alive2-intrinsics";
          version = "20.0";
          
          src = pkgs.fetchFromGitHub {
            owner = "AliveToolkit";
            repo = "alive2";
            rev = "v20.0";
            sha256 = "sha256-4QNrBRGH+rxXwb7zTRYAixxipN3ybcXuWCmO+BLU9r4=";
          };
          
          nativeBuildInputs = with pkgs; [
            cmake
            ninja
            git
            re2c
          ];
          
          buildInputs = with pkgs; [
            z3
            llvm-custom
          ];
          
          # Match Dockerfile
          cmakeFlags = [
            "-DLLVM_DIR=${llvm-custom}/lib/cmake/llvm"
            "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
            "-DBUILD_TV=1"
          ];
          
          # Alive2 tries to run git describe for version info during build
          # Patch it to use a static version instead
          postPatch = ''
            substituteInPlace CMakeLists.txt \
              --replace-fail '"''${GIT_EXECUTABLE}" describe --tags --dirty --always' \
                             '"${pkgs.coreutils}/bin/echo" "v20.0"' \
              --replace-fail '"-Wall -Werror -fPIC' \
                             '"-Wall -fPIC'
          '';
          
          # Alive2 doesn't install libraries, only executables
          # We need to manually install the static libraries for Minotaur
          postInstall = ''
            mkdir -p $out/lib
            # Find and copy all static libraries from the build directory
            find . -name "*.a" -exec cp -v {} $out/lib/ \;
          '';
          
          meta = with pkgs.lib; {
            description = "Alive2 with semantics for intrinsics";
            homepage = "https://github.com/AliveToolkit/alive2";
            license = licenses.mit;
          };
        };
        
        # Minotaur package
        minotaur = pkgs.stdenv.mkDerivation {
          pname = "minotaur";
          version = self.rev or "dirty";
          
          src = ./.;
          
          nativeBuildInputs = with pkgs; [
            cmake
            ninja
            git
            re2c
          ];
          
          buildInputs = with pkgs; [
            llvm-custom
            z3
            hiredis
            redis
            gtest
            perlPackages.BSDResource
            perlPackages.Redis
          ];
          
          cmakeFlags = [
            "-DALIVE2_SOURCE_DIR=${alive2-intrinsics.src}"
            "-DALIVE2_BUILD_DIR=${alive2-intrinsics}/lib"
            "-DCMAKE_PREFIX_PATH=${llvm-custom}"
            "-DCMAKE_EXPORT_COMPILE_COMMANDS=1"
            "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
          ];
          
          # Minotaur also tries to run git describe for version
          postPatch = ''
            substituteInPlace CMakeLists.txt \
              --replace-fail '"''${GIT_EXECUTABLE}" describe --tags --dirty --always' \
                             '"${pkgs.coreutils}/bin/echo" "nix-build"'
          '';
          
          checkInputs = with pkgs; [
            python3
          ];
          
          # Tests require Redis and other runtime setup, skip for now -- TODO: Readd ninja check
          doCheck = false;
          
          installPhase = ''
            mkdir -p $out/bin
            cp minotaur-cc minotaur-c++ slice-cc slice-c++ $out/bin/
            cp cache-dump cache-infer get-cost infer-cut.sh opt-minotaur.sh $out/bin/
          '';
          
          meta = with pkgs.lib; {
            description = "A Synthesizing Superoptimizer for LLVM";
            homepage = "https://github.com/minotaur-toolkit/minotaur";
            license = licenses.mit;
            platforms = platforms.unix;
            maintainers = [];
          };
        };
        
      in
      {
        packages = {
          default = minotaur;
          inherit minotaur llvm-custom alive2-intrinsics;
        };
        
        apps = {
          default = flake-utils.lib.mkApp {
            drv = minotaur;
            exePath = "/bin/opt-minotaur.sh";
          };
          
          minotaur-cc = flake-utils.lib.mkApp {
            drv = minotaur;
            exePath = "/bin/minotaur-cc";
          };
          
          minotaur-slice = flake-utils.lib.mkApp {
            drv = minotaur;
            exePath = "/bin/minotaur-slice";
          };
          
          cache-dump = flake-utils.lib.mkApp {
            drv = minotaur;
            exePath = "/bin/cache-dump";
          };
          
          cache-infer = flake-utils.lib.mkApp {
            drv = minotaur;
            exePath = "/bin/cache-infer";
          };
        };
        
        devShells = {
          default = pkgs.mkShell {
            inputsFrom = [ minotaur ];
            
            buildInputs = with pkgs; [
              # Additional development tools
              python3
              redis
              
              # Debugging tools
              gdb
              lldb
              valgrind
              
              # Code formatting/linting
              clang-tools
            ];
            
            shellHook = ''
              echo "Minotaur development environment (Flake)"
              echo "========================================"
              echo ""
              echo "Available commands:"
              echo "  - cmake, ninja: Build tools"
              echo "  - minotaur-cc, minotaur-c++: Compiler wrappers"
              echo "  - cache-dump, cache-infer: Cache utilities"
              echo ""
              echo "Using patched LLVM from minotaur-toolkit (llvmorg-20.1.8-patched)"
              echo "Custom LLVM with RTTI/EH: ${llvm-custom}"
              echo "Alive2 with intrinsics: ${alive2-intrinsics}"
              echo ""
              echo "To build the project:"
              echo "  mkdir -p build && cd build"
              echo "  cmake -DALIVE2_SOURCE_DIR=${alive2-intrinsics.src} \\"
              echo "        -DALIVE2_BUILD_DIR=${alive2-intrinsics} \\"
              echo "        -DCMAKE_PREFIX_PATH=${llvm-custom} \\"
              echo "        -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \\"
              echo "        -DCMAKE_BUILD_TYPE=RelWithDebInfo \\"
              echo "        -G Ninja .."
              echo "  ninja"
              echo ""
              echo "To run tests:"
              echo "  ninja check"
              echo ""
              
              # Start redis in background if not running
              if ! pgrep -x redis-server > /dev/null; then
                echo "Starting Redis server..."
                ${pkgs.redis}/bin/redis-server --daemonize yes --port 6379
              fi
            '';
            
            NIX_CFLAGS_COMPILE = "-std=c++20";
            
            LLVM_DIR = "${llvm-custom}";
            ALIVE2_SOURCE_DIR = "${alive2-intrinsics.src}";
            ALIVE2_BUILD_DIR = "${alive2-intrinsics}";
          };
          
          # Minimal shell without heavy dependencies (for quick access)
          minimal = pkgs.mkShell {
            buildInputs = with pkgs; [
              cmake
              ninja
              git
              re2c
            ];
            
            shellHook = ''
              echo "Minotaur minimal development shell"
              echo "Use 'nix develop' for the full environment"
            '';
          };
        };
        
        # Hydra/CI job
        hydraJobs = {
          inherit minotaur;
        };
      }
    );
}
