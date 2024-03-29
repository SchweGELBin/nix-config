{ config, pkgs, inputs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "rebuild" ''
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
      git clone --depth 1 https://github.com/NvChad/NvChad.git ~/.config/nvim
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
      echo "Place your Music (YouTube) links to ~/.config/nix/music.txt"
      input=~/.config/nix/music.txt
      while read -r line
      do
        mpv $line --no-video
      done < "$input"
    '')
  ];
}
