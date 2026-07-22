{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    darktable
    krita
    # wacomtablet
    libwacom
    xf86_input_wacom
  ];
}
