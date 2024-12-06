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
    hashcat
    zip2hashcat
  ];

  shellHook = ''

    echo 🔨 Cyber Sercurity DevShell


  '';
}
