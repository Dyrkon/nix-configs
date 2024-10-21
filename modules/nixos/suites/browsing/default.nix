{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.browsing;
in {
  options.${namespace}.suites.browsing = {
    enable = mkBoolOpt false "Whether or not to enable browsing configuration.";
  };

  config = mkIf cfg.enable {
    dyrkonix = {
      browsers = {
        firefox = enabled;
        chromium = enabled;
      };
    };
  };
}
