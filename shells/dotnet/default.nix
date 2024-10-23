{
  mkShell,
  pkgs,
  ...
}:
mkShell {
  packages = with pkgs; [
    azure-cli
    dotnetbuildhelpers
    dotnetPackages.Nuget
    msbuild
    netcoredbg
    powershell
    vimPlugins.neotest-dotnet
    vscode-extensions.ms-dotnettools.csharp
  ];

  shellHook = ''

    echo 🔨 Dotnet DevShell


  '';
}
