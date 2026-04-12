{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;
  cfg = config.${namespace}.virtualization.kvm;
in {
  options.${namespace}.virtualization.kvm = {
    enable = mkBoolOpt false "Whether or not to enable KVM virtualization and bridge networking.";
  };

  config = mkIf cfg.enable {
    programs.dconf.enable = true;

    dyrkonix = {
      user = {
        extraGroups = [
          "disk"
          "input"
          "kvm"
          "libvirtd"
          "qemu-libvirtd"
        ];
      };
    };

    networking = {
      bridges = {
        "br0" = {
          interfaces = [ "eno1" ];
        };
      };
      interfaces."br0".useDHCP = true;
      interfaces."eno1".useDHCP = false;
    };

    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      virt-install
      spice
      spice-gtk
      spice-protocol
      virtio-win
      win-spice
      adwaita-icon-theme
    ];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          verbatimConfig = ''
            bridge_helper = "/run/wrappers/bin/qemu-bridge-helper"
          '';
        };
      };
      spiceUSBRedirection.enable = true;
    };

    environment.etc."qemu/bridge.conf".text = "allow br0";

    services.spice-vdagentd.enable = true;
  };
}