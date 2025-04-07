{
  config,
  pkgs,
  lib,
  ...
}:
let
  vars = import ../nix/vars.nix;
in
{
  config = lib.mkIf config.scripts.enable {
    home.packages = [
      (pkgs.writeShellScriptBin "rebuild" ''
        cd ${vars.user.config}
        git add .
        nixos-rebuild switch --flake ./#home
      '')

      (pkgs.writeShellScriptBin "update" ''
        cd ${vars.user.config}
        nix flake update
      '')

      (pkgs.writeShellScriptBin "server-rebuild" ''
        cd ${vars.user.config}
        git add .
        nixos-rebuild switch --flake ./#server
      '')

      (pkgs.writeShellScriptBin "server-reset" ''
        rm -rf ${vars.user.config}
        git clone ${vars.my.repo} --depth 1 ${vars.user.config}
        cp /root/bak/{hardware-configuration.nix,networking.nix} ${vars.user.config}/hosts/server/
      '')

      (pkgs.writeShellScriptBin "music" ''
        if [[ ! -z $(pgrep music-instance) || ! -z $(pgrep mpv) ]]; then
          pkill music-instance && pkill mpv
        else
          music-instance
        fi
      '')

      (pkgs.writeShellScriptBin "music-instance" ''
        input=~/.config/nix/music.list
        while read -r line
        do
          mpv $line --no-video --slang=en
        done < "$input"
      '')

      (pkgs.writeShellScriptBin "loopback" ''
        if [[ $(pactl list | grep module-loopback) ]]; then
          pactl unload-module module-loopback
        else
          pactl load-module module-loopback
        fi
      '')

      (pkgs.writeShellScriptBin "screenshot" ''
        filename="$(date '+%Y-%m-%d_%H-%M-%S').png"
        scrDir="$HOME/Pictures/Screenshots"
        scrPath="$scrDir/$filename"

        mkdir -p $scrDir

        case $1 in
        d) # Display
          grim -o "$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')" $scrPath | wl-copy
        ;;
        w) # Window
          echo "Window mode not working yet"
        ;;
        r) # Region
          grim -g "$(slurp)" $scrPath | wl-copy
        ;;
        h) # Help
          echo "Usage: $0 <option>"
        	echo "d - Display"
        	echo "w - Window"
        	echo "r - Region"
        	echo "h - Help"
        ;;
        esac

        notify-send "Screenshot taken"
      '')

      (pkgs.writeShellScriptBin "binds" ''
        main=$(printf "%-8s" "$(cat .config/hypr/hyprland.conf | grep "\$mainMod=" | cut -c 10-)")
        alt=$(printf "%-7s" "$(cat .config/hypr/hyprland.conf | grep "\$altMod=" | cut -c 9-)")
        cat ${vars.user.home}/.config/hypr/hyprland.conf | grep "bindd=" | cut -c 7- | tr -d "," | sed "s|\$mainMod|$main|g" | sed "s|\$altMod|$alt|g"
      '')

      (pkgs.writeShellScriptBin "avabg" ''
        pkill cava
        pkill glava
        if [[ $2 == "t" && ! -z $(pgrep avabg-instance) ]]; then
          pkill avabg-instance
        else
          avabg-instance $1
        fi
      '')

      (pkgs.writeShellScriptBin "avabg-instance" ''
        case $1 in
        c) # Cava
          alacritty --class 'hyprbg' --config-file '${vars.user.home}/.config/alacritty/cava.toml' -e 'cava'
        ;;
        gl) # GLava
          echo "I don't know how to set the class for GLava"
        ;;
        esac
      '')

      (pkgs.writeShellScriptBin "ac" ''
        pkill -x ydotool
        ydotool click 0x80
        ydotool click 0x81
        case $1 in
        l) # Left
          ydotool click -r 50 -D 50 0xC0
        ;;
        r) # Right
          ydotool click -r 100 -D 25 0xC1
        ;;
        esac
      '')
    ];
  };

  options = {
    scripts.enable = lib.mkEnableOption "Enable Scripts";
  };
}
