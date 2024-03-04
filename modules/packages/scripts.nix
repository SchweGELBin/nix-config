{ config, pkgs, inputs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "rebuild" ''
      git add /etc/nixos/HyprNix
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
    (pkgs.writeShellScriptBin "minecraft-wayland" ''
      echo "Downloads newest glfw with minecraft wayland patch"
      echo "In prismlaucher open [ Settings - Minecraft - Tweaks - Native library workarounds ]"
      echo "Enable \"Use system installation of GLFW\" and paste this path: /home/michi/glfw/libglfw.so.3.4"
      rm -r ~/glfw
      mkdir ~/glfw
      cd ~/glfw
      wget https://github.com/BoyOrigin/glfw-wayland/releases/latest/download/libglfw.so.3.4
    '')
  ];
}
