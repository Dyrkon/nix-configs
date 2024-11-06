{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.data-analysis;
in {
  options.${namespace}.suites.data-analysis = {
    enable = mkBoolOpt false "Whether or not to enable data-analysis tools configuration.";
  };

  config = mkIf cfg.enable {
    dyrkonix = {
      mapping = {
        qgis = enabled;
      };
    };
  };
}
