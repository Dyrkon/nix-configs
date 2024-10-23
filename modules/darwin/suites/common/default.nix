{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.common;
in {
  imports = [(lib.snowfall.fs.get-file "modules/shared/suites/common/default.nix")];

  config = mkIf cfg.enable {
    programs.zsh.enable = true;

    homebrew = {
      brews = [
        "bashdb"
        "gnu-sed"
      ];
    };

    environment = {
      loginShell = pkgs.zsh;

      systemPackages = with pkgs; [
        bash-completion
        cask
        gawk
        gnugrep
        gnupg
        gnused
        gnutls
        haskellPackages.sfnt2woff
        intltool
        keychain
        moreutils
        rename
      ];
    };

    dyrkonix = {
      nix = enabled;

      tools = {
        homebrew = enabled;
      };

      system = {
        # fonts = enabled;
        # input = enabled;
        # interface = enabled;
        networking = enabled;
      };
    };
  };
}
