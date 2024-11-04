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
      tools = {
        utilities = enabled;
        zerotier = enabled;
        remote-desktop = enabled;
        networking = enabled;
      };
      
      virtualization = {
        docker = enabled;
        kvm = enabled;
        podman = enabled;
      };
    };
  };
}
