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
- To sync the config with a newer version run `sudo git fetch && sudo git pull` inside of */etc/nixos*
- Feel free to contribute to make these configs better
- Run `sudo rebuild` *(home)* or `sudo rebuild-server` *(server)* to rebuild the system
- You should change the initial password with `passwd`
- View the keybinds with *"SUPER + ALT"*
