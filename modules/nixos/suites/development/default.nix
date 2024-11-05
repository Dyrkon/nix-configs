{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.development;
in {
  options.${namespace}.suites.development = {
    enable = mkBoolOpt false "Whether or not to enable development configuration.";
  };

  config = mkIf cfg.enable {
    dyrkonix = {
      virtualization = {
        docker = enabled;
        kvm = enabled;
        podman = enabled;
      };
    };
  };
}
