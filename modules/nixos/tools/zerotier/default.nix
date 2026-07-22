{...}: {
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "9f77fc393e21b526"
      "af78bf94369281cd"
      "0cccb752f79256ec"
    ];
    port = 9993;
  };
}
