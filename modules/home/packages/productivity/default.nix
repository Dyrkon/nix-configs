{
  config,
  pkgs,
  lib,
  namespace,
  ...
}: let
  cfg = config.${namespace}.packages.productivity;
in {
  options.${namespace}.packages.productivity.enable = lib.mkEnableOption "Productivity tools";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      obsidian
    ];
  };
}
