{ inputs, ... }:
{
  imports = [
    ../../modules/hm
    inputs.catppuccin.homeModules.default
  ];

  # Custom modules
  hm-pkgs.server.enable = true;
}
