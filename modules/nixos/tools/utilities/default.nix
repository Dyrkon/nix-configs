{pkgs, ...}: {
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    htop
    fzf
    grc
    piper
    kdePackages.filelight
    gparted
    zip
    unzip
    lshw
    exfatprogs
    steam-run
    usbutils
    isoimagewriter
    fastfetch
  ];
}
