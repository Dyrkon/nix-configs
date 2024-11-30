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
  # All other arguments come from the system system.
  config,
  ...
}: let
  inherit (lib) types;
  inherit (lib.${namespace}) mkOpt;
  cfg = config.${namespace}.user;
in {
  options.${namespace}.user = with types; {
    email = mkOpt str "dyrkon603@gmail.com" "The email of the user.";
    extraGroups = mkOpt (listOf str) [] "Groups for the user to be assigned.";
    extraOptions = mkOpt attrs {} "Extra options passed to <option>users.users.<name></option>.";
    fullName = mkOpt str "Matej Mudra" "The full name of the user.";
    initialPassword =
      mkOpt str "password"
      "The initial password to use when the user is first created.";
    name = mkOpt str "dyrkon" "The name to use for the user account.";
  };

  config = {
    users.users.${cfg.name} =
      {
        shell = pkgs.fish;
        isNormalUser = true;
        home = "/home/${cfg.name}";
        group = "users";
        uid = 1027;
        extraGroups = ["wheel"];
      }
      // cfg.extraOptions;
  };
}
