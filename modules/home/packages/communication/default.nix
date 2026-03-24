{
  config,
  pkgs,
  lib,
  namespace,
  ...
}: let
  cfg = config.${namespace}.packages.communication;
in {
  options.${namespace}.packages.communication.enable = lib.mkEnableOption "Communication apps";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
      # element-desktop
    ];
  };
}
