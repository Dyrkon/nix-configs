{
  config,
  pkgs,
  lib,
  namespace,
  ...
}: let
  cfg = config.${namespace}.packages.ides;
in {
  options.${namespace}.packages.ides.enable = lib.mkEnableOption "JetBrains IDEs";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      jetbrains.pycharm
      jetbrains.rider
      jetbrains.clion
    ];
  };
}
