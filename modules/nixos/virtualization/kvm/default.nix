{pkgs, ...}: {
  programs.dconf.enable = true;

  networking = {
    bridges."br0".interfaces = ["eno1"];
    interfaces."br0".useDHCP = true;
    interfaces."eno1".useDHCP = false;
  };

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    bridge-utils
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        verbatimConfig = ''
          bridge_helper = "/run/wrappers/bin/qemu-bridge-helper"
        '';
      };
    };
  };

  environment.etc."qemu/bridge.conf".text = "allow br0";

  services.spice-vdagentd.enable = true;
}
