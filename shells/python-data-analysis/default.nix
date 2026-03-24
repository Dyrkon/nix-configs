{
  mkShell,
  pkgs,
  ...
}:
mkShell {
  packages = with pkgs; [
    (python310.withPackages (ps:
      with ps; [
        jupyterlab
        jupyterlab-lsp
        python-lsp-server
        ipython
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
    echo "🔨 Python DevShell"
    echo "Run: jupyter lab"
  '';
}
