{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ~/Pictures/Wallpapers/wallpaper.jpg
    wallpaper = ,~/Pictures/Wallpapers/wallpaper.jpg
  '';

  home.file.".config/hypr/hypridle.conf".text = ''
    general {
        lock_cmd = pidof hyprlock || hyprlock       # avoid starting multiple hyprlock instances.
        before_sleep_cmd = loginctl lock-session    # lock before suspend.
        after_sleep_cmd = hyprctl dispatch dpms on  # to avoid having to press a key twice to turn on the display.
    }

    listener {
        timeout = 150                                # 2.5min.
        on-timeout = brightnessctl -s set 10         # set monitor backlight to minimum, avoid 0 on OLED monitor.
        on-resume = brightnessctl -r                 # monitor backlight restore.
    }

    # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
    listener { 
        timeout = 150                                          # 2.5min.
        on-timeout = brightnessctl -sd rgb:kbd_backlight set 0 # turn off keyboard backlight.
        on-resume = brightnessctl -rd rgb:kbd_backlight        # turn on keyboard backlight.
    }

    listener {
        timeout = 300                                 # 5min
        on-timeout = loginctl lock-session            # lock screen when timeout has passed
    }

    listener {
        timeout = 330                                 # 5.5min
        on-timeout = hyprctl dispatch dpms off        # screen off when timeout has passed
        on-resume = hyprctl dispatch dpms on          # screen on when activity is detected after timeout has fired.
    }

    listener {
        timeout = 1800                                # 30min
        on-timeout = systemctl suspend                # suspend pc
    }
  '';

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  wayland.windowManager.hyprland.settings = {

    "$applauncher" = "fuzzel";
    "$browser" = "firefox";
    "$discord" = "vesktop";
    "$filemanager" = "nemo";
    "$mainMod" = "SUPER";
    "$terminal" = "kitty";

    animations = {
      enabled = "yes";
      animation = [
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "workspaces, 1, 6, default"
      ];
      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
    };

    bind = [
      # General
      "$mainMod, C, killactive, "
      "$mainMod, D, exec, $discord"
      "$mainMod, E, exec, $filemanager"
      "$mainMod, F, fullscreen"
      "$mainMod, J, togglesplit, "
      "$mainMod, K, exec, hyprpicker -f hex -a"
      "$mainMod, L, exec, mangohud legendary launch Sugar"
      "$mainMod, M, exec, music"
      "$mainMod, O, exec, $browser"
      "$mainMod, P, pseudo, "
      "$mainMod, Q, exec, $terminal"
      "$mainMod, R, exec, $applauncher"
      "$mainMod, V, togglefloating, "
      "$mainMod, W, exec, pkill waybar && waybar"

      # Focus
      "$mainMod, down, movefocus, d"
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, Tab, focusmonitor, +1"
      "$mainMod SHIFT, Tab, focusmonitor, -1"

      # Workspaces
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"

      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"

      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"

      # Screenshots
      ", Print, exec, screenshot d" # Display
      "SHIFT, Print, exec, screenshot r" # Region
      "$mainMod, Print, exec, screenshot w" # Window
    ];

    bindel = [
      # Volume
      ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
    ];

    bindl = [
      # Audio Mute
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ];

    bindm = [
      # Window Resize / Move
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    decoration = {
      blur = {
        enabled = true;
        passes = 1;
        size = 3;
      };
      drop_shadow = "yes";
      rounding = 10;
      shadow_range = 4;
      shadow_render_power = 3;
    };

    dwindle = {
      preserve_split = "yes";
      pseudotile = "yes";
    };

    env = [
      "HYPRCURSOR_THEME,Bibata-Modern-Ice"
      "HYPRCURSOR_SIZE,24"
    ];

    exec-once = [
      "hyprpaper"
      "openrgb -c FF0000"
      "waybar"
    ];

    general = {
      allow_tearing = false;
      border_size = 2;
      gaps_in = 5;
      gaps_out = 20;
      layout = "dwindle";
    };

    gestures = {
      workspace_swipe = "off";
    };

    input = {
      follow_mouse = 1;
      force_no_accel = 1;
      kb_layout = "us,us";
      kb_options = "caps:backspace, grp:win_space_toggle";
      kb_variant = ",colemak";
      sensitivity = 0;
      touchpad = {
        natural_scroll = "no";
      };
    };

    master = {
      new_is_master = true;
    };

    misc = {
      force_default_wallpaper = -1;
    };

    monitor = [
      ",preferred,auto,auto"
      "Unknown-1,disable"
    ];
  };
}
