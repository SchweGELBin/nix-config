{
  pkgs,
  config,
  inputs,
  ...
}:
{
  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv = {
      enable = true;
      package = inputs.nix-direnv.packages.${pkgs.system}.nix-direnv;
    };
  };
}
