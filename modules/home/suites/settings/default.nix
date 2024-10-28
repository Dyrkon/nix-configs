{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.settings;
in {
  options.${namespace}.suites.settings = {
    enable = mkBoolOpt false "Whether or not to enable plasma settings.";
  };

  config = mkIf cfg.enable {
    dyrkonix = {
      settings = {
        plasma = enabled;
      };
    };
  };
}
