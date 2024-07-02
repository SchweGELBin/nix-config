let
  vars = import ../nix/vars.nix;
in
{
  programs.helix = {
    enable = true;
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
        line-number = "relative";
      };
      theme = "catppuccin-${vars.cat.flavor}";
    };
  };
}
