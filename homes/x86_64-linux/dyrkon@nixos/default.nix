{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  dyrkonix = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };

    suites = {
      settings = enabled;
    };
  };

  home.stateVersion = "21.11";
}
