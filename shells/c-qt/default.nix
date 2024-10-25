{
  mkShell,
  pkgs,
  ...
}: let
in
  mkShell {
    packages = with pkgs;
      lib.optionals pkgs.stdenv.isLinux [
        # QT
        kdePackages.qt5compat
        xorg.libxcb
        xorg.libXinerama
        libudev-zero
        libusbp
        fox

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
        ";
  }
