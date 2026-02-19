{
  config,
  lib,
  pkgs,
  modulesPath,
  namespace,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel" "v4l2loopback" "nvidia-uvm"];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback.out
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback exclisive_caps=1 card_label="Virtual Camera"
  '';

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

  # GPU settings
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [libva libva-vdpau-driver libvdpau-va-gl libgpg-error];
  };

  # NVIDIA drivers are unfree.
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
    ];

  # Tell Xorg to use the nvidia driver
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is needed for most wayland compositors
    modesetting.enable = true;

    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    open = true;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
