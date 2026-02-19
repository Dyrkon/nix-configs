{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.suites.desktop;
in {
  options.${namespace}.suites.desktop = {
    enable = mkBoolOpt false "Whether or not to enable common desktop applications.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      lib.optionals pkgs.stdenv.isLinux [
        bitwarden-desktop
        gparted
        kdePackages.ark
        kdePackages.gwenview
        realvnc-vnc-viewer
      ];
  };
}
