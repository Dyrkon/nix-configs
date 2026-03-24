{
  config,
  pkgs,
  lib,
  namespace,
  ...
}: let
  cfg = config.${namespace}.packages.editing;
in {
  options.${namespace}.packages.editing.enable = lib.mkEnableOption "Photo editing tools";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # gimp
      # darktable
    ];
  };
}
