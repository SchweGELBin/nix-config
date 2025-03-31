{
  inputs,
  ...
}:
let
  vars = import ../../modules/nix/vars.nix;
in
{
  home = {
    homeDirectory = "${vars.user.home}";
    stateVersion = "${vars.user.stateVersion}";
    username = "${vars.user.name}";
  };

  imports = [
    ../../modules/hm
    inputs.catppuccin.homeModules.default
  ];

  # Custom modules
  hm-pkgs.server.enable = true;
}
