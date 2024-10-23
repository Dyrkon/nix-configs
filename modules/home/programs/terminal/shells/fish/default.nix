{
  config,
  lib,
  pkgs,
  osConfig,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.terminal.shell.fish;
in {
  options.${namespace}.programs.terminal.shell.fish = {
    enable = mkBoolOpt false "Whether to enable fish.";
  };

  config = mkIf cfg.enable {
    # xdg.configFile."fish/functions" = {
    #   source = lib.cleanSourceWith { src = lib.cleanSource ./functions/.; };
    #   recursive = true;
    # };

    programs.fish = {
      enable = true;

      loginShellInit = let
        # This naive quoting is good enough in this case. There shouldn't be any
        # double quotes in the input string, and it needs to be double quoted in case
        # it contains a space (which is unlikely!)
        dquote = str: "\"" + str + "\"";

        makeBinPathList = map (path: path + "/bin");
      in
        lib.optionalString pkgs.stdenv.isDarwin # fish
        
        ''
          export NIX_PATH="darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels:$NIX_PATH"
          fish_add_path --move --prepend --path ${
            lib.concatMapStringsSep " " dquote (makeBinPathList osConfig.environment.profiles)
          }
          set fish_user_paths $fish_user_paths
        '';

      interactiveShellInit =
        # fish
        lib.optionalString pkgs.stdenv.isDarwin ''
          # Brew environment
          if [ -f /opt/homebrew/bin/brew ];
          	eval "$("/opt/homebrew/bin/brew" shellenv)"
          end

          # Nix
          if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish' ];
           source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
          end
          if [ -f '/nix/var/nix/profiles/default/etc/profile.d/nix.fish' ];
           source '/nix/var/nix/profiles/default/etc/profile.d/nix.fish'
          end
          # End Nix
        ''
        + ''
          # Disable greeting
          set fish_greeting

          # ${lib.optionalString config.programs.fastfetch.enable "fastfetch"}
        '';

      plugins = [
        # Enable a plugin (here grc for colorized command output) from nixpkgs
        {
          name = "plugin-git";
          src = pkgs.fishPlugins.plugin-git.src;
        }
        {
          name = "sponge";
          inherit (pkgs.fishPlugins.sponge) src;
        }
      ];
    };
  };
}
