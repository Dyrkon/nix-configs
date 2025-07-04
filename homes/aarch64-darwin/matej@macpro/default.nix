{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkForce;
  inherit (lib.${namespace}) enabled disabled;
in {
  dyrkonix = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };

    programs = {
      git.enable = true;
      fish.enable = true;
      vscode.enable = true;
    };

    packages = {
      utilities.enable = true;
      productivity.enable = true;
      communication.enable = true;
      development.enable = true;
      ides.enable = true;
      media.enable = true;
      editing.enable = true;
    };

    services = {
      sops = {
        enable = false;
        defaultSopsFile = lib.snowfall.fs.get-file "secrets/secrets.yaml";
        sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
      };
    };

    spotlight-patch.enable = true;
  };

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
