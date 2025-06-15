{
  config,
  pkgs,
  lib,
  namespace,
  ...
}: let
  cfg = config.${namespace}.packages.development;
in {
  options.${namespace}.packages.development.enable = lib.mkEnableOption "Development tools";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      curl
      podman
      qemu
    ];
  };
}
