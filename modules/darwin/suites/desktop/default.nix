{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.desktop;
in {
  options.${namespace}.suites.desktop = {
    enable = mkBoolOpt false "Whether or not to enable common desktop configuration.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      brews = [
      ];

      casks = [
        "bitwarden"
        "firefox-developer-edition"
        "gpg-suite"
        "kitty"
      ];

      taps = [
        "beeftornado/rmtree"
        "bramstein/webfonttools"
        "felixkratz/homebrew-formulae"
        "khanhas/tap"
        "romkatv/powerlevel10k"
        "teamookla/speedtest"
      ];

      masApps = mkIf config.${namespace}.tools.homebrew.masEnable {
        "AdGuard for Safari" = 1440147259;
        "AutoMounter" = 1160435653;
        "Dark Reader for Safari" = 1438243180;
        "Disk Speed Test" = 425264550;
        "Microsoft Remote Desktop" = 1295203466;
        "PopClip" = 445189367;
        "WiFi Explorer" = 494803304;
      };
    };
  };
}
