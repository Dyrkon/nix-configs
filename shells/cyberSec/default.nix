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
    binwalk
    p7zip
  ];

  shellHook = ''

    echo 🔨 Cyber Sercurity DevShell


  '';
}
