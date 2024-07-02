{
  home.file."rust/.envrc".text = ''use nix /etc/nixos/modules/hm/devshells/rust.nix'';
  home.file."tauri/.envrc".text = ''
    use nix /etc/nixos/modules/hm/devshells/rust.nix
    use nix /etc/nixos/modules/hm/devshells/tauri.nix
  '';
}
