{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.sys.services.sound.enable {
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
      pulse.enable = true;
    };
  };

  options = {
    sys.services.sound.enable = lib.mkEnableOption "Enable Sound";
  };
}
