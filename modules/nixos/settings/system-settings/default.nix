{inputs, ...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.opentabletdriver.enable = true;

  systemd.user.services.wayland-config = {
    script = ''
      xrandr --output DP-1 --primary
    '';
    wantedBy = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
  };

  system.autoUpgrade = {
    enable = true;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L"
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };
}
