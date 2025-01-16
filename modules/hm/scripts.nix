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
        rm -rf /etc/nixos
        sudo git clone ${vars.my.repo} --depth 1 /etc/nixos
        sudo cp /root/bak/{hardware-configuration.nix,networking.nix} /etc/nixos/hosts/server/
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
          mpv $line --no-video --slang=en,eng,de,deu,ger
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
          echo "Use: screenshot <option>"
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

      (pkgs.writeShellScriptBin "cavabg" ''
        pkill -x cava
        if [[ $1 = "t" && ! -z $(pgrep cavabg-instance) ]]; then
          pkill cavabg-instance
        else
          cavabg-instance
        fi
      '')

      (pkgs.writeShellScriptBin "cavabg-instance" ''
        alacritty --class 'hyprbg' --config-file '${vars.user.home}/.config/alacritty/cava.toml' -e 'cava'
      '')
    ];
  };

  options = {
    scripts.enable = lib.mkEnableOption "Enable Scripts";
  };
}
