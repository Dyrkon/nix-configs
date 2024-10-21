{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.office;
in {
  options.${namespace}.suites.office = {
    enable = mkBoolOpt false "Whether or not to enable creative configuration.";
  };

  config = mkIf cfg.enable {
    dyrkonix = {
      writing = {
        text = enabled;
        development = enabled;
      };
    };
  };
}
