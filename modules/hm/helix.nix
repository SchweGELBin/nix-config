{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.helix;
  vars = import ../nix/vars.nix;
in
{
  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;
      extraPackages = with pkgs; [
        bash-language-server
        jdt-language-server
        kotlin-language-server
        lldb
        markdown-oxide
        marksman
        nil
        nixfmt-rfc-style
        taplo
      ];
      languages.language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "nixfmt";
        }
        {
          name = "rust";
          auto-format = true;
          formatter.command = "rustfmt";
        }
      ];
      settings = {
        editor = {
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
          #insert-final-newline = false;
          line-number = "relative";
        };
        theme = lib.mkIf config.theme.catppuccin.enable "catppuccin-${vars.cat.flavor}";
      };
    };
  };

  options = {
    helix.enable = lib.mkEnableOption "Enable Helix";
  };
}
