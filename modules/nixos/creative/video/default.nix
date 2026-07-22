{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # davinci-resolve
    vlc
    clapper
    ffmpeg
    obs-studio
  ];
}
