{
  # Check out https://tauri.app/ 
  # Check out https://tauri.app/v1/guides/getting-started/prerequisites/
  # pnpm create tauri-app
  home.file."tauri/.envrc".text = ''
    use nix /etc/nixos/modules/hm/devshells/tauri.nix
  '';
}
