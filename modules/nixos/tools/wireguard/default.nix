{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  namespace, # The namespace used for your flake, defaulting to "internal" if not set.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  # All other arguments come from the module system.
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;
  cfg = config.${namespace}.tools.wireguard;
in {
  options.${namespace}.tools.wireguard = {
    enable = mkBoolOpt false "Whether or not to enable wireguard VPN.";
  };
  config = mkIf cfg.enable {
    networking.wireguard.enable = true;
    networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.200.200.22/32" ];
      privateKeyFile = config.sops.secrets."private-keys/wireguard".path;
      
      peers = [
        {
          publicKey = "5u32ZrXqWPAofCt4E6hSW/sNxOzBHBSP37vE4EJg/kE=";
          presharedKey = "IGqyhU2GMhbgEXT7xaU0IJ/O5b4Qh3TXMF+r5cXVPfw=";
          allowedIPs = [ "10.200.200.0/24" "192.168.100.0/24" ];
          endpoint = "wg.nesad.fit.vutbr.cz:51820";
          persistentKeepalive = 16;
        }
      ];
    };
  };
  };
}
