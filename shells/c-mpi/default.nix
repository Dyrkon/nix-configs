{
  mkShell,
  pkgs,
  ...
}: let
in
  mkShell {
    packages = with pkgs;
      lib.optionals pkgs.stdenv.isLinux [
        # MPI
        mpi

        # Development Tools
        llvmPackages_14.clang
        gnumake
        cmake
        cmakeCurses
        gdb

        # Build time and Run time dependencies
        spdlog
        abseil-cpp
      ];

    shellHook = "
        export MPI_INCLUDE=${pkgs.mpi.dev}/include
        export MPI_LIB=${pkgs.mpi.dev}/lib
        export MPI_CC=${pkgs.mpi.dev}/bin/mpicc
        export MPI_CXX=${pkgs.mpi.dev}/bin/mpicxx

        rm -rf build
        mkdir build
        ";
  }
