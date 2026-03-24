{
  mkShell,
  pkgs,
  ...
}:
mkShell {
  packages = with pkgs;
    [
      curl
      foremost
      nmap
      john
      fcrackzip
      bkcrack
      hashcat
      zip2hashcat
      binwalk
      p7zip
      metasploit
      (python3.withPackages (ps:
        with ps; [
          cryptography
        ]))
    ]
    ++ lib.optional pkgs.stdenv.isLinux [ghex vsftpd];

  shellHook = ''
    echo 🔨 Cyber Sercurity DevShell

  '';
}
