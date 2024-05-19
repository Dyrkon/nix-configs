{pkgs, ...}: {
  programs.git.enable = true;
  programs.git.config = {
    user.name = "Matej Mudra";
    user.email = "dyrkon603@gmail.com";
    safe.directory = [
      "/etc/nixos"
    ];
    extraConfig = {
      color.ui = true;
      core.editor = "vim";
      push.default = "simple";
      pull.rebase = true;
    };
  };
}
