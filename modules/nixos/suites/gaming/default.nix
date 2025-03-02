{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.gaming;
in {
  options.${namespace}.suites.gaming = {
    enable = mkBoolOpt false "Whether or not to enable gaming configuration.";
  };

  config = mkIf cfg.enable {
    dyrkonix = {
      gaming = {
        controllers = enabled;
        mouse = enabled;
        steam = enabled;
        wine = enabled;
        simracing = enabled;
        vr = enabled;
        launchers = enabled;
      };
    };
  };
}
