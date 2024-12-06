{
  mkShell,
  pkgs,
  ...
}:
mkShell {
  packages = with pkgs; [
    curl
    foremost
    ghex
    vsftpd
    nmap
    john
    fcrackzip
    bkcrack
  ];

  shellHook = ''

    echo 🔨 Cyber Sercurity DevShell


  '';
}
