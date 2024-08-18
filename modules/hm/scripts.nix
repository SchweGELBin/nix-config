{ pkgs, ... }:
let
  vars = import ../nix/vars.nix;
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "rebuild" ''
      cd ${vars.user.config}
      git add ${vars.user.config}
      nix flake update
      nixfmt ${vars.user.config}
      nixos-rebuild switch --flake ${vars.user.config}/#default
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
}
