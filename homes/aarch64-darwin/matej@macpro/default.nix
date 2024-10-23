{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkForce;
  inherit (lib.${namespace}) enabled disabled;
in {
  dyrkonix = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };

    programs = {
      terminal = {
        shell = {
          fish = enabled;
        };
      };
    };

    # suites = {
    #   business = enabled;
    #   common = enabled;
    #   desktop = enabled;
    #   # development = {
    #   #   enable = true;
    #   #   nixEnable = true;
    #   # };
    #   # music = enabled;
    #   # networking = enabled;
    #   # photo = enabled;
    #   # social = enabled;
    # };
  };

  home.stateVersion = "23.05";
}
