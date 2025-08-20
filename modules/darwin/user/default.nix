{
  lib,
  pkgs,
  inputs,
  namespace, # The namespace used for your flake, defaulting to "internal" if not set.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your definegd hosts.
  config,
  ...
}: let
  inherit (lib) types mkIf;
  inherit (lib.${namespace}) mkOpt mkBoolOpt;
  cfg = config.${namespace}.user;
in {
  options.${namespace}.user = with types; {
    enable = mkBoolOpt false "Enable user module";
    email = mkOpt str "dyrkon603@gmail.com" "The email of the user.";
    extraGroups = mkOpt (listOf str) [] "Groups for the user to be assigned.";
    extraOptions = mkOpt attrs {} "Extra options passed to <option>users.users.<name></option>.";
    fullName = mkOpt str "Matej Mudra" "The full name of the user.";
    name = mkOpt str "matej" "The name to use for the user account.";
  };

  config = mkIf config.${namespace}.user.enable {
    # TODO remove before fresh install
    ids.gids.nixbld = 30000;
  };
}
