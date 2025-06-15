{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) mkOpt mkBoolOpt;
  cfg = config.${namespace}.programs.fish;
in {
  options.${namespace}.programs.fish.enable = mkBoolOpt false "Enable fish at system level";

  config = lib.mkIf cfg.enable {
    programs.fish.enable = true;
  };
}
