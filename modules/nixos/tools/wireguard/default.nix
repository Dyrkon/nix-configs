{config, ...}: {
  networking.wireguard.enable = true;
  networking.wg-quick.interfaces = {
    wg0 = {
      address = ["10.200.200.22/32"];
      privateKeyFile = config.sops.secrets."private-keys/wireguard".path;

      peers = [
        {
          publicKey = "5u32ZrXqWPAofCt4E6hSW/sNxOzBHBSP37vE4EJg/kE=";
          presharedKey = "IGqyhU2GMhbgEXT7xaU0IJ/O5b4Qh3TXMF+r5cXVPfw=";
          allowedIPs = ["10.200.200.0/24" "192.168.100.0/24"];
          endpoint = "wg.nesad.fit.vutbr.cz:51820";
          persistentKeepalive = 16;
        }
      ];
    };
  };
}
