{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.common;
in {
  options.${namespace}.suites.common = {
    enable = mkBoolOpt false "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      nixcfg = "nvim ~/${namespace}/flake.nix";
    };

    home.packages = with pkgs; [
      ncdu
      smassh
      toilet
      tree
    ];

    dyrkonix = {
      programs = {
        graphical = {
          browsers = {
            firefox = enabled;
          };
        };

        terminal = {
          shell = {
            fish = enabled;
          };

          tools = {
            git = enabled;
          };
        };
      };
    };

    # xdg.configFile.wgetrc.text = "";
  };
}
