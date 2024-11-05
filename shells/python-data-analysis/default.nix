{
  mkShell,
  pkgs,
  ...
}:
mkShell {
  packages = with pkgs; [
    (python3.withPackages (ps:
      with ps; [
        ipython
        jupyter
        numpy
        pandas
        matplotlib
        scipy
        seaborn
        statsmodels
        openpyxl
        texliveSmall
        pypdf2
      ]))
  ];

  shellHook = ''

    echo 🔨 Python DevShell


  '';
}
