{
  config,
  pkgs,
  lib,
  ...
}:
let
  vars = import ../../nix/vars.nix;
in
{
  config = lib.mkIf config.scripts.enable {
    home.packages = [
      (pkgs.writeShellScriptBin "rebuild" ''
        cd ${vars.user.config}
        git add ${vars.user.config}
        nixfmt ${vars.user.config}
        nixos-rebuild switch --flake ${vars.user.config}/#home
      '')

      (pkgs.writeShellScriptBin "update" ''
        cd ${vars.user.config}
        nix flake update
      '')

      (pkgs.writeShellScriptBin "server-rebuild" ''
        cd ${vars.user.config}
        git add ${vars.user.config}
        nixos-rebuild switch --flake ${vars.user.config}/#server
      '')

      (pkgs.writeShellScriptBin "server-reset" ''
        rm -rf /etc/nixos
        sudo git clone ${vars.git.repo} --depth 1 /etc/nixos
        sudo cp /root/bak/{hardware-configuration.nix,networking.nix} /etc/nixos/hosts/server/
      '')

      (pkgs.writeShellScriptBin "music" ''
        if [[ ! -z $(pgrep music-instance) ]] || [[ ! -z $(pgrep mpv) ]]; then
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
    ];
  };

  options = {
    scripts.enable = lib.mkEnableOption "Enable Scripts";
  };
}
