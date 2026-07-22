{...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = "";

    shellAliases = {
      "rebuild" = "darwin-rebuild switch --flake ~/.config/configuration/flake.nix";
      "ndf" = "nix develop --command fish";
      "svc" = "sudo vim /etc/nixos/configuration.nix";
      "snr" = "sudo nixos-rebuild switch";
      "sup" = "svc && snr";
      "startup" = "firefox && obsidian && spotify";
      "find-strays" = "sudo -i nix-store --gc --print-roots | egrep -v '^(/nix/var|/run/current-system|/run/booted-system|/proc|{memory|{censored)'";
    };
  };
}
