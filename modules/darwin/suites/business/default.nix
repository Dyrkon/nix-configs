{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.business;
in {
  options.${namespace}.suites.business = {
    enable = mkBoolOpt false "Whether or not to enable business configuration.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "bitwarden"
        "libreoffice"
        "thunderbird"
      ];

      masApps = mkIf config.${namespace}.tools.homebrew.masEnable {
        "Brother iPrint&Scan" = 1193539993;
        "Numbers" = 409203825;
        "Pages" = 409201541;
      };
    };

    dyrkonix = {
    };
  };
}
