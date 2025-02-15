# nix-config
My Nix configs

## Configuration
```
Window Manager       - Hyprland
Terminal             - Kitty
Browser              - Firefox
Explorer             - Nemo
Application Launcher - Fuzzel
Bar                  - Waybar
Audio                - Pipewire
Boot Manager         - Grub
Editor               - Helix
Theme                - Catppuccin Mocha Mauve
```

### Preview
![Desktop](./res/desktop.png)

## Apply
- [Home Configuration](./docs/Install_Home.md)
- [Server Configuration](./docs/Install_Server.md)

## Tips
### General
- To sync the config with a newer version run `sudo git fetch && sudo git pull` inside of */etc/nixos*
- You should change the initial password with `passwd`
- Feel free to contribute to make these configs better

### Keybinds
- View the keybinds with *"SUPER + ALT_R"*

### Scripts
```
sudo rebuild         | Rebuild Home system
sudo update          | Update Home config
sudo server-rebuild  | Rebuild Server system
sudo server-reset    | Reset Server config
music                | Toogle music-instance
music-instance       | Play music
loopback             | Toggle mic loopback
screenshot [d/w/r/h] | Take screenshot (Display/Window/Region/Help)
```
