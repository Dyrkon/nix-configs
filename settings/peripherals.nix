{ pkgs, ... }:
{
  # Enable wacom tablet
  hardware.opentabletdriver.enable = true;

  # Wayland config script
  systemd.user.services.wayland-config = {
    script = ''
    xrandr --output DP-1 --primary
    '';
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
  };

  # Enable BT
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Noise-torch noise supression
  programs.noisetorch.enable = true;
}