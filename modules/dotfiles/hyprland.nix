{config, pkgs, ...}:
{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    monitor = ",preferred,auto,auto";

    exec-once = "waybar";

    env = "XCURSOR_SIZE,24";

    input = {
      kb_layout = "us,us";
      kb_variant = ",colemak";
      kb_options = "caps:backspace, grp:win_space_toggle";

      follow_mouse = 1;

      touchpad = {
        natural_scroll = "no";
      };
      
      sensitivity = 0;
      force_no_accel = 1;
    };

    general = {
      gaps_in = 5;
      gaps_out = 20;
      border_size = 2;
      "col.active_border" = "rgba(${config.colorScheme.palette.base07}ee) rgba(${config.colorScheme.palette.base0F}ee) 45deg";
      "col.inactive_border" = "rgba(${config.colorScheme.palette.base01}aa)";

      layout = "dwindle";

      allow_tearing = false;
    };

    decoration = {
      rounding = 10;
    
      blur = {
        enabled = true;
        size = 3;
        passes = 1;
      };

      drop_shadow = "yes";
      shadow_range = 4;
      shadow_render_power = 3;
      "col.shadow" = "rgba(${config.colorScheme.palette.base01}ee)";
    };

    animations = {
      enabled = "yes";

      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };

    dwindle = {
      pseudotile = "yes";
      preserve_split = "yes";
    };

    master = {
      new_is_master = true;
    };

    gestures = {
      workspace_swipe = "off";
    };

    misc = {
      force_default_wallpaper = -1;
    }; 

    "$mainMod" = "SUPER";

    "$applauncher" = "rofi";
    "$browser" = "firefox";
    "$filemanager" = "dolphin";
    "$terminal" = "kitty";

    "$screenshotdir" = "~/Pictures/Screenshots/";

    bind = [
      # General
      "$mainMod, Q, exec, $terminal"
      "$mainMod, C, killactive, "
      "$mainMod, M, exit, "
      "$mainMod, E, exec, $filemanager"
      "$mainMod, V, togglefloating, "
      #"$mainMod, exec, $applauncher -cheatsheet"
      "$mainMod, L, exec, rofimoji"
      "$mainMod, R, exec, $applauncher -show drun -show-icons"
      "$mainMod, P, pseudo, "
      "$mainMod, J, togglesplit, "
      "$mainMod, O, exec, $browser"

      # Focus
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"

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
      ", Print, exec, hyprshot  -c -o $screenshotdir -m output"
      "$mainMod, Print, exec, hyprshot -c -o $screenshotdir -m window"
      "SHIFT, Print, exec, hyprshot -o $screenshotdir -m region"

      # Reset
      "$mainMod, W, exec, pkill waybar && waybar"

      # FullScreen
      "$mainMod, F, fullscreen"
    ];

    bindm = [
      # Window Resize / Move
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    bindel = [
      # Volume
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-" 
    ];

    bindl = [
      # Audio Mute
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ];
  };
}
