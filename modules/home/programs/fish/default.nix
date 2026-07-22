{config, pkgs, ...}: {
  home.sessionVariables = {
    EDITOR = "vim";
    SHELL = "${pkgs.fish}/bin/fish";
  };

  home.sessionPath = [
    "/etc/profiles/per-user/${config.home.username}/bin"
    "/nix/var/nix/profiles/system/sw/bin"
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = "";
    plugins = [
      {
        name = "plugin-git";
        src = pkgs.fishPlugins.plugin-git.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
    ];
    shellAliases = {
      rebuild = "darwin-rebuild switch --flake ~/.config/configuration/flake.nix";
      ndf = "nix develop --extra-experimental-features ca-derivations --command fish";
    };
  };
}
