{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      signing.format = "openpgp";
    };
  };

  options = {
    git.enable = lib.mkEnableOption "Enable Git";
  };
}
