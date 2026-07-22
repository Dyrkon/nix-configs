{pkgs, ...}: {
  environment.systemPackages = [pkgs.pixiecore];

  security.wrappers.pixiecore = {
    owner = "root";
    group = "root";
    source = "${pkgs.pixiecore}/bin/pixiecore";
    capabilities = "cap_net_raw,cap_net_bind_service+ep";
    permissions = "0755";
    setuid = false;
    setgid = false;
  };
}
