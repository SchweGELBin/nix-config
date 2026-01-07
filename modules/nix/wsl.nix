{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.wsl;
  vars = import ../vars.nix;
in
{
  imports = [ inputs.nixos-wsl.nixosModules.default ];

  config = lib.mkIf cfg.enable {
    wsl = {
      enable = true;
      defaultUser = vars.user.name;
    };
  };

  options = {
    sys.wsl.enable = lib.mkEnableOption "Enable WSL";
  };
}
