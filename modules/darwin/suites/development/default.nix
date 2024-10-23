{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.suites.development;
in {
  options.${namespace}.suites.development = {
    enable = mkBoolOpt false "Whether or not to enable common development configuration.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "docker"
        "electron"
        "powershell"
        "visual-studio-code"
      ];

      masApps = mkIf config.${namespace}.tools.homebrew.masEnable {
        # FIXME: keeps trying to reinstall it
        # "Xcode" = 497799835;
      };
    };
  };
}
