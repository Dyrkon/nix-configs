{pgks, ...}: {
  # Steam overlay
  nixpkgs.overlays = [
    (final: prev: {
      steam = prev.steam.override ({extraPkgs ? pkgs': [], ...}: {
        extraPkgs = pkgs':
          (extraPkgs pkgs')
          ++ (with pkgs'; [
            libgdiplus
          ]);
      });
    })
  ];

  # Enable steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    # gamescopeSession.enable = true; # Enable gamescope
  };
}
