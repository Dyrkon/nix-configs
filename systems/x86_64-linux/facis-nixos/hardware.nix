{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}: let
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel" "v4l2loopback" "hid-fanatec" "nvidia-uvm"];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback.out
    # fanatecff
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback exclisive_caps=1 card_label="Virtual Camera"
  '';
  # services.udev.packages = [fanatecff];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/106961b2-dd40-4047-8aec-fb91d55239d5";
    fsType = "btrfs";
    options = ["subvol=root"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/106961b2-dd40-4047-8aec-fb91d55239d5";
    fsType = "btrfs";
    options = ["subvol=nix"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6737-98EE";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/3666aa85-a9dd-4d77-b2bd-942361d22300";
    fsType = "btrfs";
  };

  # Swap device
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  hardware.xpadneo.enable = true; # Enable support for Xbox One controllers

  # GPU settings
  # Make sure opengl is enabled
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [libva vaapiVdpau libvdpau-va-gl libgpg-error];
  };

  # NVIDIA drivers are unfree.
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
    ];

  nixpkgs.config = {
    nvidia.acceptLicense = true;
  };

  # Tell Xorg to use the nvidia driver
  services.xserver.videoDrivers = ["nvidia"];

  systemd.services.nvidia-control-devices = {
    wantedBy = ["multi-user.target"];
    serviceConfig.ExecStart = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi";
  };
  hardware.nvidia-container-toolkit.enable = true;
  hardware.nvidia.open = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.modesetting.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
