{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}: let
  # fanatecff = config.boot.kernelPackages.callPackage ./users/packages/fanatec.nix {};
  mkNvidia = args: let
    imported = import "${inputs.nixpkgs}/pkgs/os-specific/linux/nvidia-x11/generic.nix" args;
  in
    config.boot.kernelPackages.callPackage imported {
      lib32 =
        (pkgs.pkgsi686Linux.callPackage imported {
          libsOnly = true;
          kernel = null;
        })
        .out;
    };

  compatibleDriver = mkNvidia {
    version = "525.147.05";
    sha256_64bit = "sha256-Q1GD6lRcfhLjBE15htoHdYozab7+fuUZ6zsGPUrz/vE=";
    settingsSha256 = "sha256-8RW/G70jr8IV5++Aw+dd5kyhiHMgYFWPWQfmhO7FFjM=";
    persistencedSha256 = "sha256-rQHmTKB3/8V42kqg7hZiRleiW7ApKZ0eIembM9w78PQ=";
  };
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
    device = "/dev/disk/by-uuid/4f20c617-82af-41c2-8ba5-18d0894d5359";
    fsType = "btrfs";
    options = ["subvol=@"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/756D-83B9";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/3666aa85-a9dd-4d77-b2bd-942361d22300";
    fsType = "btrfs";
  };

  hardware.xpadneo.enable = true; # Enable support for Xbox One controllers

  # GPU settings
  # Make sure opengl is enabled
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
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

  hardware.nvidia = {
    # Modesetting is needed for most wayland compositors
    modesetting.enable = true;

    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    # open = true;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
    package = compatibleDriver;
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
