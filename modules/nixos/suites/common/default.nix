{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.common;
in {
  options.${namespace}.suites.common = {
    enable = mkBoolOpt false "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {
    dyrkonix = {
      hardware = {
        bluetooth = enabled;
        networking = enabled;
        sound = enabled;
        additional-hardware = enabled;
      };

      settings = {
        localization = enabled;
      };

      tools = {
        utilities = enabled;
        zerotier = enabled;
        wireguard = enabled;
        remote-desktop = enabled;
        networking = enabled;
      };

      services = {
        general = enabled;
      };

      nix = enabled;

      programs = {
        terminal = {
          shell = {
            fish = enabled;
          };
        };
      };
    };
  };
}
