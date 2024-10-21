{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.creative;
in {
  options.${namespace}.suites.creative = {
    enable = mkBoolOpt false "Whether or not to enable creative configuration.";
  };

  config = mkIf cfg.enable {
    dyrkonix = {
      creative = {
        video = enabled;
        photo = enabled;
        music = enabled;
        multid = enabled;
      };
    };
  };
}
