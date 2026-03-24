{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) mkBoolOpt mkOpt;

  cfg = config.${namespace}.security.pxe-config;
in {
  options.${namespace}.security.pxe-config = with lib.types; {
    enable = mkBoolOpt false "Whether to enable pxe support.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.pixiecore];

    security.wrappers.pixiecore = {
      owner = "root";
      group = "root";
      source = "${pkgs.pixiecore}/bin/pixiecore";
      capabilities = "cap_net_raw,cap_net_bind_service+ep";
      permissions = "0755";
      setuid = false;
      setgid = false;
    };
  };
}
