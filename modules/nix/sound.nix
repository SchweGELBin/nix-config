{
  config,
  lib,
  ...
}:
let
  cfg = config.sys.sound;
in
{
  config = lib.mkIf cfg.enable {
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
    sys.sound.enable = lib.mkEnableOption "Enable Sound";
  };
}
