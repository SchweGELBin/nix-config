{ inputs, pkgs, ... }:
let
  vars = import ../nix/vars.nix;
in
{
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ~/Pictures/Wallpapers/wallpaper.png
    wallpaper = ,~/Pictures/Wallpapers/wallpaper.png
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
  home.file.".config/hypr/binds.sh".source = ./scripts/binds.sh;

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprtrails
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
    ];
    settings = {

      "$alt" = "\$${vars.cat.alt}";
      "$altMod" = "ALT";
      "$applauncher" = "fuzzel";
      "$bar" = "waybar";
      "$browser" = "firefox";
      "$discord" = "vesktop";
      "$filemanager" = "nemo";
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";

      animations = {
        enabled = true;
        animation = [
          "border, 1, 10, default"
          "borderangle, 1, 60, linear, loop"
          "fade, 1, 7, default"
          "windows, 1, 7, window"
          "windowsOut, 1, 7, default, popin 80%"
          "workspaces, 1, 6, default"
        ];
        bezier = [
          "linear, 0.0, 0.0, 1.0, 1.0"
          "window, 0.05, 0.9, 0.1, 1.05"
        ];
      };

      bindd = [
        "$altMod   SHIFT, up,   Add window to master,                           layoutmsg, addmaster"
        "$mainMod, mouse_down,  Go to next workspace,                           workspace, e+1"
        "$mainMod, mouse_up,    Go to previous workspace,                       workspace, e-1"
        "$mainMod, 0,           Go to workspace 0,                              workspace, 0"
        "$mainMod, 1,           Go to workspace 1,                              workspace, 1"
        "$mainMod, 2,           Go to workspace 2,                              workspace, 2"
        "$mainMod, 3,           Go to workspace 3,                              workspace, 3"
        "$mainMod, 4,           Go to workspace 4,                              workspace, 4"
        "$mainMod, 5,           Go to workspace 5,                              workspace, 5"
        "$mainMod, 6,           Go to workspace 6,                              workspace, 6"
        "$mainMod, 7,           Go to workspace 7,                              workspace, 7"
        "$mainMod, 8,           Go to workspace 8,                              workspace, 8"
        "$mainMod, 9,           Go to workspace 9,                              workspace, 9"
        "$mainMod, C,           Kill active window,                             killactive, "
        "$mainMod, RETURN,      Launch App Launcher ($applauncher),             exec, $applauncher"
        "$mainMod, A,           Launch Browser ($browser),                      exec, $browser"
        "$mainMod, K,           Launch Color Picker,                            exec, hyprpicker -f hex -a"
        "$mainMod, O,           Launch Discord client ($discord),               exec, $discord"
        "$mainMod, E,           Launch File Manager ($filemanager),             exec, $filemanager"
        "$mainMod, K,           Launch Rocket League,                           exec, mangohud legendary launch Sugar"
        "$mainMod, Q,           Launch Terminal ($terminal),                    exec, $terminal"
        "$mainMod  SHIFT, S,    Move current workspace to special workspace,    movetoworkspace, special:magic"
        "$mainMod, down,        Move focus down,                                movefocus, d"
        "$mainMod, left,        Move focus left,                                movefocus, l"
        "$mainMod, right,       Move focus right,                               movefocus, r"
        "$mainMod, up,          Move focus up,                                  movefocus, u"
        "$altMod,  ALT_L,       Move focus to master or first child,            layoutmsg, focusmaster"
        "$mainMod, Tab,         Move focus to next monitor,                     focusmonitor, +1"
        "$altMod,  right,       Move focus to next window,                      layoutmsg, cyclenext"
        "$mainMod  SHIFT, Tab,  Move focus to previous monitor,                 focusmonitor, -1"
        "$altMod,  left,        Move focus to previous window,                  layoutmsg, cycleprev"
        "$mainMod  SHIFT, 0,    Move focused window and go to workspace 0,      movetoworkspace, 0"
        "$mainMod  SHIFT, 1,    Move focused window and go to workspace 1,      movetoworkspace, 1"
        "$mainMod  SHIFT, 2,    Move focused window and go to workspace 2,      movetoworkspace, 2"
        "$mainMod  SHIFT, 3,    Move focused window and go to workspace 3,      movetoworkspace, 3"
        "$mainMod  SHIFT, 4,    Move focused window and go to workspace 4,      movetoworkspace, 4"
        "$mainMod  SHIFT, 5,    Move focused window and go to workspace 5,      movetoworkspace, 5"
        "$mainMod  SHIFT, 6,    Move focused window and go to workspace 6,      movetoworkspace, 6"
        "$mainMod  SHIFT, 7,    Move focused window and go to workspace 7,      movetoworkspace, 7"
        "$mainMod  SHIFT, 8,    Move focused window and go to workspace 8,      movetoworkspace, 8"
        "$mainMod  SHIFT, 9,    Move focused window and go to workspace 9,      movetoworkspace, 9"
        "$mainMod, L,           Play Music,                                     exec, music"
        "$altMod   SHIFT, down, Remove window from master,                      layoutmsg, removemaster"
        "$mainMod, D,           Restart Bar ($bar),                             exec, pkill $bar && $bar"
        "SUPER,    ALT_L,       Show Keybinds,                                  exec, kitty \"${vars.user.home}/.config/hypr/binds.sh\""
        "$mainMod, grave,       Show Workspaces,                                hyprexpo:expo, toggle"
        "$altMod,  Tab,         Swap focused window with master or first child, layoutmsg, swapwithmaster"
        "$altMod,  up,          Swap focused window with next one,              layoutmsg,   swapnext"
        "$altMod,  down,        Swap focused window with previous one,          layoutmsg, swapprev"
        ",         Print,       Take Screenshot of current Display,             exec, screenshot d"
        "$mainMod, Print,       Take Screenshot of focused Window,              exec, screenshot w"
        "SHIFT,    Print,       Take Screenshot of selected Region,             exec, screenshot r"
        "$mainMod, H,           Toggle floating window,                         togglefloating, "
        "$mainMod, T,           Toggle fullscreen,                              fullscreen, "
        "$mainMod, I,           Toggle h/w window split,                        togglesplit, "
        "$mainMod, P,           Toggle pseudo (Keep aspect ratio),              pseudo, "
        "$mainMod, S,           Toggle special workspace,                       togglespecialworkspace, magic"
      ];

      binddel = [
        ", XF86MonBrightnessDown, Decrease Brightness, exec, brightnessctl s 10%-"
        ", XF86AudioLowerVolume,  Decrease Volume,     exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp,   Increase Brightness, exec, brightnessctl s 10%+"
        ", XF86AudioRaiseVolume,  Increase Volume,     exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
      ];

      binddl = [
        ", XF86AudioNext,    Media Next,     exec, playerctl next"
        ", XF86AudioPlay,    Media Play,     exec, playerctl play-pause"
        ", XF86AudioPrev,    Media Previous, exec, playerctl previous"
        ", XF86AudioMute,    Mute Audio,     exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, Mute Mic,      exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];

      binddm = [
        # Window Resize / Move
        "$mainMod, mouse:272, Move Window, movewindow"
        "$mainMod, mouse:273, Resize Window, resizewindow"
      ];

      decoration = {
        "col.shadow" = "$surface0";
        active_opacity = 0.75;
        blur = {
          enabled = true;
          passes = 1;
          size = 3;
          vibrancy = 0.17;
        };
        drop_shadow = true;
        inactive_opacity = 0.9;
        rounding = 12;
        shadow_range = 4;
        shadow_render_power = 3;
      };

      dwindle = {
        preserve_split = true;
        pseudotile = true;
      };

      exec-once = [
        "hyprpaper"
        #"kitty -c \"~/.config/kitty/kittybg.conf\" --class=\"kitty-bg\" \"${vars.user.home}/.config/kitty/cavabg.sh\""
        "openrgb -c $accentAlpha"
        "waybar"
      ];

      general = {
        "col.active_border" = "$accent $alt 45deg";
        "col.inactive_border" = "$alt";
        allow_tearing = false;
        border_size = 2;
        gaps_in = 4;
        gaps_out = 12;
        layout = "master";
        resize_on_border = false;
      };

      gestures = {
        workspace_swipe = false;
      };

      input = {
        follow_mouse = 1;
        force_no_accel = 1;
        kb_layout = "us,us";
        kb_options = "caps:backspace, grp:win_space_toggle";
        kb_variant = "workman,";
        sensitivity = 0;
        touchpad = {
          natural_scroll = false;
        };
      };

      master = {
        allow_small_split = true;
        new_on_top = true;
        new_status = "master";
      };

      misc = {
        disable_hyprland_logo = false;
        force_default_wallpaper = -1;
      };

      monitor = [
        ",preferred,auto,1" # Default
        "Unknown-1,disable" # Ghost Monitor
        "DP-2,2560x1440@180,0x0,1,bitdepth,8,vrr,1,transform,0" # Main
      ];

      plugin = {
        hyprexpo = {
          columns = 3;
          gap_size = 5;
          bg_col = "$accent";
          workspace_method = "first 1";
        };
        hyprtrails.color = "$accent";
        hyprwinwrap.class = "kitty-bg";
      };
    };
  };
}
