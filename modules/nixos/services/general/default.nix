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

  cfg = config.${namespace}.services.general;
in {
  options.${namespace}.services.general = {
    enable = mkBoolOpt false "Whether or not to configure system services.";
  };

  config = mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;
    services.displayManager.sddm.wayland.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # OpenVPN
    services.openvpn.servers = {
    };

    # Enable remote
    services.xrdp = {
      enable = true;
      openFirewall = true;
      defaultWindowManager = "startplasma-x11";
    };

    systemd.user.services.set-volume = {
      description = "Set audio volume to 100% on login";
      after = [ "sound.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "pactl set-sink-volume alsa_output.usb-BEHRINGER_UMC202HD_192k-00.pro-output-0 100%";
      };
      wantedBy = [ "default.target" ];
    };
  };
}
