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
        lsp.display-messages = true;
      };
      keys.normal = {
        space.space = "file_picker";
        space.w = ":w";
        space.q = ":q";
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
      };
    };
  };
}
