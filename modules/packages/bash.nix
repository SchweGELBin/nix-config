{config, pkgs, ...}:
{
  home.file.".bashrc" = {
    text = ''
      fastfetch
    '';
  };
}
