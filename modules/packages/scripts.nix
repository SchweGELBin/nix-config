{ config, pkgs, inputs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "rebuild" ''
      cd /etc/nixos
      git add /etc/nixos/
      nix flake update
      nixos-rebuild switch --flake /etc/nixos/#default
    '')

    (pkgs.writeShellScriptBin "inject-payload" ''
      echo "Injects the newest Switch payload"
      echo "Make sure, you have an unpatched switch with the jig inserted"
      echo "Connect your switch to your pc via a charging cable, power off your switch, hold Volume up + down for a second"
      echo "Now, you can run \"inject-payload\""
      cd ~
      wget https://github.com/Atmosphere-NX/Atmosphere/releases/latest/download/fusee.bin && fusee-nano ~/fusee.bin && rm ~/fusee.bin
    '')

    (pkgs.writeShellScriptBin "nvchad" ''
      rm -r ~/.config/nvim
      rm -r ~/.local/share/nvim
      git clone --depth 1 https://github.com/NvChad/starter.git ~/.config/nvim
    '') 

    (pkgs.writeShellScriptBin "music" ''
      echo "Place your Music (YouTube) links to ~/.config/nix/music.list"
      echo "Tip: Run cava in another window"
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
        #grim $scrPath | wl-copy
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
