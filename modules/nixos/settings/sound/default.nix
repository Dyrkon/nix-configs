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

  cfg = config.${namespace}.hardware.sound;
in {
  options.${namespace}.hardware.sound = {
    enable = mkBoolOpt false "Whether or not to enable support for sound settings.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      alsa-utils
      pavucontrol
      helvum
    ];

    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      wireplumber.enable = true;
    };

    services.pipewire.wireplumber.extraConfig.bluetooth = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true; # higher-quality SBC (often huge improvement)
        "bluez5.enable-msbc" = true; # better HFP if it happens
        "bluez5.enable-hw-volume" = true;

        # Prefer A2DP for playback; avoid auto-favoring headset role
        "bluez5.roles" = ["a2dp_sink" "a2dp_source"];
      };
    };

    programs.noisetorch.enable = true;
  };
}
