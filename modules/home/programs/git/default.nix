{...}: {
  programs.git = {
    enable = true;
    settings.user = {
      name = "Matej Mudra";
      email = "dyrkon603@gmail.com";
    };
    settings.push.autoSetupRemote = true;
  };
}
