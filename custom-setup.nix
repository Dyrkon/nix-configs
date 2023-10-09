# Custom nix setup file
{ config, lib, pkgs, modulesPath, ... }:

{
  systemd.user.services.wayland-config = {
    script = ''
    xrandr --output DP-1 --primary
    '';
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
  };

  services.zerotierone = {
    enable = true; # change to true to enable VPN
    joinNetworks = ["0cccb752f79256ec"];
  };

}
