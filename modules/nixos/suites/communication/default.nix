{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.communication;
in {
  options.${namespace}.suites.communication = {
    enable = mkBoolOpt false "Whether or not to enable creative configuration.";
  };

  config = mkIf cfg.enable {
    dyrkonix = {
      communication = {
        general = enabled;
      };
    };
  };
}
