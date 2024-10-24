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

  cfg = config.${namespace}.settings.localization;
in {
  options.${namespace}.settings.localization = {
    enable = mkBoolOpt false "Whether or not to enable support for localization setting.";
  };

  config = mkIf cfg.enable {
    # Set your time zone.
    time.timeZone = "Europe/Prague";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
     LC_ADDRESS = "cs_CZ.UTF-8";
     LC_IDENTIFICATION = "cs_CZ.UTF-8";
     LC_MEASUREMENT = "cs_CZ.UTF-8";
     LC_MONETARY = "cs_CZ.UTF-8";
     LC_NAME = "cs_CZ.UTF-8";
     LC_NUMERIC = "cs_CZ.UTF-8";
     LC_PAPER = "cs_CZ.UTF-8";
     LC_TELEPHONE = "cs_CZ.UTF-8";
     LC_TIME = "cs_CZ.UTF-8";
    };
  };
}
