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
  };

  home.stateVersion = "25.11";
}
