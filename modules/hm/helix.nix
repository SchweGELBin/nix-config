{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.helix;
  vars = import ../vars.nix;
in
{
  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;
      extraPackages = with pkgs; [
        astro-language-server
        bash-language-server
        jdt-language-server
        kotlin-language-server
        lldb
        markdown-oxide
        marksman
        nil
        nixfmt
        taplo
      ];
      languages.language = [
        {
          name = "astro";
          auto-format = true;
        }
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
          bufferline = "multiple";
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          indent-guides = {
            character = "▏";
            render = true;
            skip-levels = 1;
          };
          insert-final-newline = true;
          line-number = "relative";
          soft-wrap.enable = true;
          trim-final-newlines = true;
          trim-trailing-whitespace = true;
          whitespace.render = {
            nbsp = "all";
            nnbsp = "all";
            tab = "all";
          };
        };
        theme = lib.mkIf config.theme.catppuccin.enable "catppuccin-${vars.cat.flavor}";
      };
    };
  };

  options = {
    helix.enable = lib.mkEnableOption "Enable Helix";
  };
}
