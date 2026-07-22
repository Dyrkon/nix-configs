{pkgs, ...}: {
  services.xserver.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  services.displayManager.autoLogin = {
    enable = true;
    user = "dyrkon";
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.printing.enable = true;

  services.openvpn.servers = {};

  services.xrdp = {
    enable = true;
    openFirewall = true;
    defaultWindowManager = "startplasma-x11";
  };

  environment.systemPackages = with pkgs; [
    freerdp
  ];

  systemd.user.services.set-volume = {
    description = "Set audio volume to 100% on login";
    after = ["sound.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "pactl set-sink-volume alsa_output.usb-BEHRINGER_UMC202HD_192k-00.pro-output-0 100%";
    };
    wantedBy = ["default.target"];
  };
}
