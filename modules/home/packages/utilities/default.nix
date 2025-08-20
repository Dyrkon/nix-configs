{
  config,
  pkgs,
  lib,
  namespace,
  ...
}: let
  cfg = config.${namespace}.packages.utilities;
in {
  options.${namespace}.packages.utilities.enable = lib.mkEnableOption "Utility packages";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      htop
      fastfetch
      rectangle
      wireshark
      zstd
      # remmina
      utm
      oh-my-fish
      localsend
    ];
  };
}
