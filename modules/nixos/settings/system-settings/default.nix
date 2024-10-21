{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  namespace, # The namespace used for your flake, defaulting to "internal" if not set.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  # All other arguments come from the module system.
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.hardware.additional-hardware;
in {
  options.${namespace}.hardware.additional-hardware = {
    enable = mkBoolOpt false "Whether or not to enable support for additional hardware.";
  };

  config = mkIf cfg.enable {
    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Enable wacom tablet
    hardware.opentabletdriver.enable = true;

    # Wayland config script
    systemd.user.services.wayland-config = {
      script = ''
        xrandr --output DP-1 --primary
      '';
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
    };

    system.autoUpgrade = {
      enable = true;
      # flake = inputs.self.outPath;
      flags = [
        "--update-input"
        "nixpkgs"
        "-L" # print build logs
      ];
      dates = "02:00";
      randomizedDelaySec = "45min";
    };

    system.stateVersion = "experimental"; # Did you read the comment?
  };
}
