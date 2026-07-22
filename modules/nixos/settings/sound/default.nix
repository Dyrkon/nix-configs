{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alsa-utils
    pavucontrol
    helvum
  ];

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  services.pipewire.wireplumber.extraConfig.bluetooth = {
    "monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = true;
      "bluez5.enable-hw-volume" = true;
      "bluez5.roles" = ["a2dp_sink" "a2dp_source"];
    };
  };

  programs.noisetorch.enable = true;
}
