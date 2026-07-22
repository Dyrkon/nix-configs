{pkgs, self, ...}: let
  freejoy = self + "/misc/99-hid-FreeJoy.rules";
in {
  environment.systemPackages = with pkgs; [
    linuxKernel.packages.linux_xanmod_latest.xone
    libusbp
  ];

  services.udev.extraRules = builtins.readFile freejoy;
}
