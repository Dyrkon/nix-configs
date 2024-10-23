{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit
    (lib)
    types
    mkIf
    mkDefault
    mkMerge
    getExe
    getExe'
    ;
  inherit (lib.${namespace}) mkOpt enabled;

  cfg = config.${namespace}.user;

  home-directory =
    if cfg.name == null
    then null
    else if pkgs.stdenv.isDarwin
    then "/Users/${cfg.name}"
    else "/home/${cfg.name}";
in {
  options.${namespace}.user = {
    enable = mkOpt types.bool false "Whether to configure the user account.";
    email = mkOpt types.str "dyrkon603@gmail.com" "The email of the user.";
    fullName = mkOpt types.str "Matej Mudra" "The full name of the user.";
    home = mkOpt (types.nullOr types.str) home-directory "The user's home directory.";
    name = mkOpt (types.nullOr types.str) config.snowfallorg.user.name "The user account.";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = cfg.name != null;
          message = "${namespace}.user.name must be set";
        }
        {
          assertion = cfg.home != null;
          message = "${namespace}.user.home must be set";
        }
      ];

      home = {
        file =
          {
            "Desktop/.keep".text = "";
            "Documents/.keep".text = "";
            "Downloads/.keep".text = "";
            "Music/.keep".text = "";
            "Pictures/.keep".text = "";
            "Videos/.keep".text = "";
          };

        homeDirectory = mkDefault cfg.home;

        sessionPath = with pkgs; [
          "/etc/profiles/per-user/matej/bin"
          "/nix/var/nix/profiles/system/sw/bin"
        ];

        sessionVariables = {
          EDITOR = "vim";
          SHELL = "/etc/profiles/per-user/matej/bin/fish";
        };

        shellAliases = {
          # nix specific aliases
          cleanup = "sudo nix-collect-garbage --delete-older-than 3d && nix-collect-garbage -d";
          bloat = "nix path-info -Sh /run/current-system";
          curgen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
          gc-check = "nix-store --gc --print-roots | egrep -v \"^(/nix/var|/run/\w+-system|\{memory|/proc)\"";
          repair = "nix-store --verify --check-contents --repair";
          run = "nix run";
          search = "nix search";
          shell = "nix shell";
          rebuild = "darwin-rebuild switch --flake ~/.config/configuration/flake.nix";
          ndf = "nix develop --extra-experimental-features ca-derivations --command fish";
          nixre = "${lib.optionalString pkgs.stdenv.isLinux "sudo"} flake switch";
          # TODO: figure out how to make this nix flake check compatible
          # nixre = "${lib.optionalString pkgs.stdenv.isLinux "sudo"} ${
          #   getExe snowfall-flake.packages.${system}.flake
          # } switch";

          untar = "${getExe pkgs.gnutar} -zxvf ";

          # Navigation shortcuts
          home = "cd ~";
          ".." = "cd ..";
          "..." = "cd ../..";
          "...." = "cd ../../..";
          "....." = "cd ../../../..";
          "......" = "cd ../../../../..";

          # Colorize output
          dir = "${getExe' pkgs.coreutils "dir"} --color=auto";
          egrep = "${getExe' pkgs.gnugrep "egrep"} --color=auto";
          fgrep = "${getExe' pkgs.gnugrep "fgrep"} --color=auto";
          grep = "${getExe pkgs.gnugrep} --color=auto";
          vdir = "${getExe' pkgs.coreutils "vdir"} --color=auto";

          # Misc
          clr = "clear";
          usage = "${getExe' pkgs.coreutils "du"} -ah -d1 | sort -rn 2>/dev/null";
        };

        username = mkDefault cfg.name;
      };

      programs.home-manager = enabled;
    }
  ]);
}
