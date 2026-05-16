{ config, pkgs, ... }:

{
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "babicka";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Prague";

  i18n.defaultLocale = "cs_CZ.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.UTF-8";
    LC_IDENTIFICATION = "cs_CZ.UTF-8";
    LC_MEASUREMENT = "cs_CZ.UTF-8";
    LC_MONETARY = "cs_CZ.UTF-8";
    LC_NAME = "cs_CZ.UTF-8";
    LC_NUMERIC = "cs_CZ.UTF-8";
    LC_PAPER = "cs_CZ.UTF-8";
    LC_TELEPHONE = "cs_CZ.UTF-8";
    LC_TIME = "cs_CZ.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.xkb.layout = "cz";
  services.xserver.xkb.variant = "";

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "sona";

  console.keyMap = "cz-lat2";

  services.printing.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.pam.services.sddm.enableKwallet = true;
  security.pam.services.kwallet = {
    name = "kwallet";
    enableKwallet = true;
  };
  security.pam.services.login.enableKwallet = true;

  users.users.sona = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "Soňa Tomisová";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    firefox
    wget
    git
    vscode
    libreoffice-still
    kdePackages.filelight
    unzip
    zip
    vlc
    sshfs
    lshw
    htop
    xrdp
    wireshark
    kdePackages.kwallet-pam
    oh-my-fish
    nixfmt-rfc-style
    kdePackages.kmag
    kdePackages.kmouth
    orca
    rustdesk
    kdePackages.kcalc
    kdePackages.okular
  ];

  systemd.services.rustdesk = {
    description = "RustDesk Remote Desktop Gateway";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.rustdesk}/bin/rustdesk --service";
      Restart = "always";
    };
  };

  services.openssh.enable = true;
  services.openssh.settings.X11Forwarding = true;

  services.zerotierone = {
    enable = true;
    joinNetworks = [ "af78bf94369281cd" ];
  };

  services.xrdp.enable = true;
  services.xrdp.port = 3389;
  services.xrdp.defaultWindowManager = "${pkgs.kdePackages.plasma-workspace}/bin/startplasma-x11";
  services.xrdp.openFirewall = true;

  networking.firewall.allowedTCPPorts = [ 3389 22 ];
  networking.firewall.allowedUDPPorts = [ 3389 22 ];

  system.stateVersion = "25.11"; 
}