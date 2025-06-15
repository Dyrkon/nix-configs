{
  config,
  pkgs,
  lib,
  namespace,
  ...
}: let
  cfg = config.${namespace}.packages.media;
in {
  options.${namespace}.packages.media.enable = lib.mkEnableOption "Media applications";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      spotify
    ];
  };
}
