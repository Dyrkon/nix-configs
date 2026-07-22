{...}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Privacy = "device";
        JustWorksRepairing = "always";
        Class = "0x000100";
        FastConnectable = "true";
        Experimental = true;
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  services.blueman.enable = true;
}
