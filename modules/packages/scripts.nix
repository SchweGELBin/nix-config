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

    (pkgs.writeShellScriptBin "minecraft-wayland" '' # Remove, when glfw 3.4 is out
      echo "Downloads newest glfw with minecraft wayland patch"
      echo "In prismlaucher open [ Settings - Minecraft - Tweaks - Native library workarounds ]"
      echo "Enable \"Use system installation of GLFW\" and paste this path: /home/michi/glfw/libglfw.so.3.5"
      rm -r ~/glfw
      mkdir ~/glfw
      cd ~/glfw
      wget https://github.com/BoyOrigin/glfw-wayland/releases/latest/download/libglfw.so.3.5
    '')

    (pkgs.writeShellScriptBin "music" ''
      echo "Place your Music (YouTube) links to ~/.config/nix/music.list"
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
      grim $scrPath | wl-copy
    ;;
    w) # Window
      echo "Window mode not working yet"
    ;;
    r) # Region
      grim -g "$(slurp)" $scrPath | wl-copy
    ;;
    esac
    '')
  ];
}
