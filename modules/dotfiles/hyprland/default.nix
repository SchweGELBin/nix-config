{config, pkgs, ...}:
{
  imports = [ ./hyprland.nix ];

  home.file.".config/hyprland/screenshot.sh" = {
    text = ''
      filename = "$(date '%Y-%m-%d_%H-%M-%S').png" 
      scrPath = "~/Pictures/Screenshots/$filename"
      activeWindow = "$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')"

      case $1 in
      d) # Display
        grim $scrPath | wl-copy"
      ;;
      w) # Window
        grim -o $activeWindow $scrPath | wl-copy"
      ;;
      s) # Selection
        grim -g $(slurp) $scrPath | wl-copy"
      ;;
      esac
    '';
  };
}
