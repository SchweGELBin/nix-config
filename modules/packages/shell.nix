{config, pkgs, ...}:
{
  home.file.".bashrc" = {
    text = ''
      fastfetch
    '';
  };
  home.file.".zshrc" = {
    text = ''
      fastfetch
    '';
  };
}
