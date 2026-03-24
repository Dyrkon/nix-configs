{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) mkOpt;
  userCfg = config.${namespace}.user;
  cfg = config.${namespace}.programs.git;
in {
  options.${namespace}.programs.git = {
    enable = lib.mkEnableOption "Git support";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings.user = {
        name = userCfg.fullName;
        email = userCfg.email;
      };
      settings.push.autoSetupRemote = true;
    };
  };
}
