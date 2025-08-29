{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hypr;
  vars = import ../vars.nix;

  logo = ".face";
  monitors = {
    first = {
      name = "DP-2";
      wall = ".config/background";
      wallp = "~/${monitors.first.wall}";
    };
    second = {
      name = "DP-3";
      wall = ".config/background2";
      wallp = "~/${monitors.second.wall}";
    };
  };
in
{
  config = lib.mkIf cfg.enable {
    home = {
      file = {
        ${logo}.source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/logos/exports/1544x1544_circle.png";
          hash = "sha256-A85wBdJ2StkgODmxtNGfbNq8PU3G3kqnBAwWvQXVtqo=";
        };
        ${monitors.first.wall}.source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/SchweGELBin/artwork/main/wallpapers/2560x1440/nineish.png";
          hash = "sha256-vE94lLHTDcqshT/EcF0d/HFnsAQ7WDhvdmEod9BfpyI=";
        };
        ${monitors.second.wall}.source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/SchweGELBin/artwork/main/wallpapers/3440x1440/flake.png";
          hash = "sha256-WYbqYZ0p0VI+CUH/ZJu5StA0z4P4YjQ6uWmVfW2NqbA=";
        };
      };
      packages = with pkgs; [ ] ++ lib.optionals cfg.picker.enable [ hyprpicker ];
    };

    programs.hyprlock.enable = cfg.lock.enable;

    services = {
      hypridle = {
        enable = cfg.idle.enable;
        settings = {
          general = {
            after_sleep_cmd = "hyprctl dispatch dpms on";
            before_sleep_cmd = "loginctl lock-session";
            lock_cmd = "pgrep hyprlock || hyprlock";
          };
          listener = [
            {
              on-timeout = "loginctl lock-session";
              timeout = 300;
            }
            {
              on-resume = "hyprctl dispatch dpms on";
              on-timeout = "hyprctl dispatch dpms off";
              timeout = 330;
            }
          ];
        };
      };
      hyprpaper = {
        enable = cfg.paper.enable;
        settings = {
          preload = [
            monitors.first.wallp
            monitors.second.wallp
          ];
          wallpaper = [
            "${monitors.first.name},${monitors.first.wallp}"
            "${monitors.second.name},${monitors.second.wallp}"
          ];
        };
      };
    };

    wayland.windowManager.hyprland = {
      enable = cfg.land.enable;
      plugins =
        with pkgs.hyprlandPlugins;
        [ ]
        ++ lib.optionals cfg.land.plugins.borders-plus-plus.enable [ borders-plus-plus ]
        ++ lib.optionals cfg.land.plugins.csgo-vulkan-fix.enable [ csgo-vulkan-fix ]
        ++ lib.optionals cfg.land.plugins.hyprbars.enable [ hyprbars ]
        ++ lib.optionals cfg.land.plugins.hyprexpo.enable [ hyprexpo ]
        ++ lib.optionals cfg.land.plugins.hyprfocus.enable [ hyprfocus ]
        ++ lib.optionals cfg.land.plugins.hyprscrolling.enable [ hyprscrolling ]
        ++ lib.optionals cfg.land.plugins.hyprtrails.enable [ hyprtrails ]
        ++ lib.optionals cfg.land.plugins.hyprwinwrap.enable [ hyprwinwrap ]
        ++ lib.optionals cfg.land.plugins.xtra-dispatchers.enable [ xtra-dispatchers ];
      settings = {

        "$alt" = "\$${vars.cat.alt}";
        "$altMod" = "ALT_L";
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
          ]
          ++ lib.optionals cfg.land.plugins.hyprfocus.enable [ "hyprfocusIn, 1, 2, focus" ];
          bezier = [
            "focus, 0.25, 1, 0.5, 1"
            "linear, 0.0, 0.0, 1.0, 1.0"
            "window, 0.05, 0.9, 0.1, 1.05"
          ];
        };

        bindd = [
          "$altMod   SHIFT,  up        ,  Add window to master                          ,  layoutmsg             , addmaster"
          "          ALT_R,  left      ,  Auto Clicker Left                             ,  exec                  , ac l"
          "          ALT_R,  right     ,  Auto Clicker Right                            ,  exec                  , ac r"
          "$mainMod       ,  C         ,  Close active window                           ,  killactive            , "
          "$mainMod       ,  mouse_down,  Go to next workspace                          ,  workspace             , e+1"
          "$mainMod       ,  mouse_up  ,  Go to previous workspace                      ,  workspace             , e-1"
          "$mainMod       ,  1         ,  Go to workspace 1                             ,  workspace             , 1"
          "$mainMod       ,  KP_Home   ,  Go to workspace 1                             ,  workspace             , 1"
          "$mainMod       ,  2         ,  Go to workspace 2                             ,  workspace             , 2"
          "$mainMod       ,  KP_Up     ,  Go to workspace 2                             ,  workspace             , 2"
          "$mainMod       ,  3         ,  Go to workspace 3                             ,  workspace             , 3"
          "$mainMod       ,  KP_Prior  ,  Go to workspace 3                             ,  workspace             , 3"
          "$mainMod       ,  4         ,  Go to workspace 4                             ,  workspace             , 4"
          "$mainMod       ,  KP_Left   ,  Go to workspace 4                             ,  workspace             , 4"
          "$mainMod       ,  5         ,  Go to workspace 5                             ,  workspace             , 5"
          "$mainMod       ,  KP_Begin  ,  Go to workspace 5                             ,  workspace             , 5"
          "$mainMod       ,  6         ,  Go to workspace 6                             ,  workspace             , 6"
          "$mainMod       ,  KP_Right  ,  Go to workspace 6                             ,  workspace             , 6"
          "$mainMod       ,  7         ,  Go to workspace 7                             ,  workspace             , 7"
          "$mainMod       ,  KP_End    ,  Go to workspace 7                             ,  workspace             , 7"
          "$mainMod       ,  8         ,  Go to workspace 8                             ,  workspace             , 8"
          "$mainMod       ,  KP_Down   ,  Go to workspace 8                             ,  workspace             , 8"
          "$mainMod       ,  9         ,  Go to workspace 9                             ,  workspace             , 9"
          "$mainMod       ,  KP_Next   ,  Go to workspace 9                             ,  workspace             , 9"
          "$mainMod       ,  V         ,  Kill a window (select or exit with [esc])     ,  exec                  , hyprctl kill"
          "$mainMod       ,  RETURN    ,  Launch App Launcher ($applauncher)            ,  exec                  , $applauncher"
          "$mainMod       ,  A         ,  Launch Browser ($browser)                     ,  exec                  , $browser"
          "$mainMod       ,  K         ,  Launch Color Picker                           ,  exec                  , hyprpicker -f hex -a"
          "$mainMod       ,  D         ,  Launch Discord client ($discord)              ,  exec                  , $discord"
          "$mainMod       ,  E         ,  Launch File Manager ($filemanager)            ,  exec                  , $filemanager"
          "$mainMod       ,  escape    ,  Launch Logout Menu                            ,  exec                  , loginctl lock-session"
          "$mainMod       ,  backspace ,  Launch Resource Monitor                       ,  exec                  , kitty --hold btop"
          "$mainMod       ,  R         ,  Launch Rocket League                          ,  exec                  , xrandr --output ${monitors.second.name} --primary && mangohud legendary launch Sugar"
          "$mainMod       ,  Q         ,  Launch Terminal ($terminal)                   ,  exec                  , $terminal"
          "$mainMod  SHIFT,  S         ,  Move current workspace to special workspace   ,  movetoworkspace       , special:magic"
          "$mainMod       ,  down      ,  Move focus down                               ,  movefocus             , d"
          "$mainMod       ,  left      ,  Move focus left                               ,  movefocus             , l"
          "$mainMod       ,  right     ,  Move focus right                              ,  movefocus             , r"
          "$mainMod       ,  up        ,  Move focus up                                 ,  movefocus             , u"
          "$altMod        ,  ALT_L     ,  Move focus to master or first child           ,  layoutmsg             , focusmaster"
          "$mainMod       ,  Tab       ,  Move focus to next monitor                    ,  focusmonitor          , +1"
          "$altMod        ,  right     ,  Move focus to next window                     ,  layoutmsg             , cyclenext"
          "$mainMod  SHIFT,  Tab       ,  Move focus to previous monitor                ,  focusmonitor          , -1"
          "$altMod        ,  left      ,  Move focus to previous window                 ,  layoutmsg             , cycleprev"
          "$mainMod  SHIFT,  1         ,  Move focused window and go to workspace 1     ,  movetoworkspace       , 1"
          "$mainMod  SHIFT,  KP_Home   ,  Move focused window and go to workspace 1     ,  movetoworkspace       , 1"
          "$mainMod  SHIFT,  2         ,  Move focused window and go to workspace 2     ,  movetoworkspace       , 2"
          "$mainMod  SHIFT,  KP_Up     ,  Move focused window and go to workspace 2     ,  movetoworkspace       , 2"
          "$mainMod  SHIFT,  3         ,  Move focused window and go to workspace 3     ,  movetoworkspace       , 3"
          "$mainMod  SHIFT,  KP_Prior  ,  Move focused window and go to workspace 3     ,  movetoworkspace       , 3"
          "$mainMod  SHIFT,  4         ,  Move focused window and go to workspace 4     ,  movetoworkspace       , 4"
          "$mainMod  SHIFT,  KP_Left   ,  Move focused window and go to workspace 4     ,  movetoworkspace       , 4"
          "$mainMod  SHIFT,  5         ,  Move focused window and go to workspace 5     ,  movetoworkspace       , 5"
          "$mainMod  SHIFT,  KP_Begin  ,  Move focused window and go to workspace 5     ,  movetoworkspace       , 5"
          "$mainMod  SHIFT,  6         ,  Move focused window and go to workspace 6     ,  movetoworkspace       , 6"
          "$mainMod  SHIFT,  KP_Right  ,  Move focused window and go to workspace 6     ,  movetoworkspace       , 6"
          "$mainMod  SHIFT,  7         ,  Move focused window and go to workspace 7     ,  movetoworkspace       , 7"
          "$mainMod  SHIFT,  KP_End    ,  Move focused window and go to workspace 7     ,  movetoworkspace       , 7"
          "$mainMod  SHIFT,  8         ,  Move focused window and go to workspace 8     ,  movetoworkspace       , 8"
          "$mainMod  SHIFT,  KP_Down   ,  Move focused window and go to workspace 8     ,  movetoworkspace       , 8"
          "$mainMod  SHIFT,  9         ,  Move focused window and go to workspace 9     ,  movetoworkspace       , 9"
          "$mainMod  SHIFT,  KP_Next   ,  Move focused window and go to workspace 9     ,  movetoworkspace       , 9"
          "$mainMod       ,  M         ,  Play Music                                    ,  exec                  , music"
          "$altMod   SHIFT,  down      ,  Remove window from master                     ,  layoutmsg             , removemaster"
          "$mainMod       ,  W         ,  Restart Bar ($bar)                            ,  exec                  , pkill $bar && $bar"
          "          SUPER,  ALT_R     ,  Show Keybinds                                 ,  exec                  , kitty --hold binds"
          "$mainMod       ,  grave     ,  Show Workspaces                               ,  hyprexpo:expo         , toggle"
          "$altMod        ,  Tab       ,  Swap focused window with master or first child,  layoutmsg             , swapwithmaster"
          "$altMod        ,  up        ,  Swap focused window with next one             ,  layoutmsg             , swapnext"
          "$altMod        ,  down      ,  Swap focused window with previous one         ,  layoutmsg             , swapprev"
          "               ,  Print     ,  Take Screenshot of current Display            ,  exec                  , screenshot d"
          "$mainMod       ,  Print     ,  Take Screenshot of focused Window             ,  exec                  , screenshot w"
          "          SHIFT,  Print     ,  Take Screenshot of selected Region            ,  exec                  , screenshot r"
          "$mainMod       ,  B         ,  Toggle Cava Background                        ,  exec                  , avabg c t"
          "$mainMod  SHIFT,  B         ,  Toggle GLava Background                       ,  exec                  , avabg gl t"
          "$mainMod       ,  G         ,  Toggle floating window                        ,  togglefloating        , "
          "$mainMod       ,  F         ,  Toggle fullscreen                             ,  fullscreen            , "
          "$mainMod       ,  O         ,  Toggle h/w window split                       ,  togglesplit           , "
          "$mainMod       ,  P         ,  Toggle pseudo (Keep aspect ratio)             ,  pseudo                , "
          "$mainMod       ,  S         ,  Toggle special workspace                      ,  togglespecialworkspace, magic"
        ];

        binddel = [
          ", XF86MonBrightnessDown, Decrease Brightness, exec, brightnessctl s 10%-"
          ", XF86AudioLowerVolume,  Decrease Volume,     exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86MonBrightnessUp,   Increase Brightness, exec, brightnessctl s 10%+"
          ", XF86AudioRaiseVolume,  Increase Volume,     exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ];

        binddl = [
          "SHIFT,  XF86AudioPlay,     Kill MPV,        exec,  pkill -x mpv"
          "     ,  XF86AudioNext,     Media Next,      exec,  playerctl next"
          "     ,  XF86AudioPlay,     Media Play,      exec,  playerctl play-pause"
          "     ,  XF86AudioPrev,     Media Previous,  exec,  playerctl previous"
          "     ,  XF86AudioMute,     Mute Audio,      exec,  wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          "     ,  XF86AudioMicMute,  Mute Mic,        exec,  wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ];

        binddm = [
          "$mainMod, mouse:272, Move Window, movewindow"
          "$mainMod, mouse:273, Resize Window, resizewindow"
        ];

        debug = {
          error_position = 1;
        };

        decoration = {
          active_opacity = 0.75;
          blur.new_optimizations = !cfg.land.plugins.hyprfocus.enable;
          inactive_opacity = 0.9;
          rounding = 12;
          shadow.color = "$surface0";
        };

        dwindle = {
          preserve_split = true;
          pseudotile = true;
        };

        ecosystem = {
          no_donation_nag = true;
          no_update_news = true;
        };

        exec-once = [
          "openrgb -c $accentAlpha"
        ]
        ++ lib.optionals cfg.idle.enable [ "hypridle" ]
        ++ lib.optionals cfg.land.plugins.hyprfocus.enable [ "avabg c" ]
        ++ lib.optionals cfg.paper.enable [ "hyprpaper" ]
        ++ lib.optionals config.waybar.enable [ "waybar" ];

        general = {
          "col.active_border" = "$accent $alt 45deg";
          "col.inactive_border" = "$alt";
          border_size = 2;
          gaps_in = 4;
          gaps_out = 12;
          layout = "master";
        };

        input = {
          force_no_accel = true;
          kb_layout = "us,us";
          kb_options = "caps:backspace, grp:win_space_toggle";
          kb_variant = ", workman";
          numlock_by_default = true;
          resolve_binds_by_sym = true;
        };

        master = {
          allow_small_split = true;
          new_status = "inherit";
          orientation = "center";
          slave_count_for_center_master = 3;
        };

        misc = {
          middle_click_paste = false;
          vrr = 2;
        };

        monitor = [
          ", preferred, auto, 1"
          "Unknown-1, disable"
          "${monitors.first.name}, ${toString vars.monitors.first.res.x}x${toString vars.monitors.first.res.y}@${toString vars.monitors.first.hz}, 0x0, 1, bitdepth,${toString vars.monitors.first.bit}"
          "${monitors.second.name}, ${toString vars.monitors.second.res.x}x${toString vars.monitors.second.res.y}@${toString vars.monitors.second.hz}, ${toString vars.monitors.first.res.x}x0, 1, bitdepth,${toString vars.monitors.second.bit}"
        ];

        plugin = {
          hyprexpo = {
            columns = 3;
            gap_size = 5;
            bg_col = "$accent";
            workspace_method = "first 1";
          };
          hyprfocus.mode = "slide";
          hyprtrails.color = "$accent";
          hyprwinwrap.class = "hyprbg";
        };

        windowrule = [
          "idleinhibit focus, class:(rocketleague.exe)"
          "fullscreen, class:(rocketleague.exe)"
          "fullscreen, title:(Minecraft)(.*)"
        ];
      };
    };
  };

  options = {
    hypr = {
      enable = lib.mkEnableOption "Enable Hypr*";
      idle.enable = lib.mkEnableOption "Enable hypridle";
      land = {
        enable = lib.mkEnableOption "Enable Hyprland";
        plugins = {
          enable = lib.mkEnableOption "Enable Hyprland Plugins";
          borders-plus-plus.enable = lib.mkEnableOption "Enable Hyprland Plugin: borders-plus-plus";
          csgo-vulkan-fix.enable = lib.mkEnableOption "Enable Hyprland Plugin: csgo-vulkan-fix";
          hyprbars.enable = lib.mkEnableOption "Enable Hyprland Plugin: hyprbars";
          hyprexpo.enable = lib.mkEnableOption "Enable Hyprland Plugin: hyprexpo";
          hyprfocus.enable = lib.mkEnableOption "Enable Hyprland Plugin: hyprfocus";
          hyprscrolling.enable = lib.mkEnableOption "Enable Hyprland Plugin: hyprscrolling";
          hyprtrails.enable = lib.mkEnableOption "Enable Hyprland Plugin: hyprtrails";
          hyprwinwrap.enable = lib.mkEnableOption "Enable Hyprland Plugin: hyprwinwrap";
          xtra-dispatchers.enable = lib.mkEnableOption "Enable Hyprland Plugin: xtra-dispatchers";
        };
      };
      lock.enable = lib.mkEnableOption "Enable hyprlock";
      paper.enable = lib.mkEnableOption "Enable hyprpaper";
      picker.enable = lib.mkEnableOption "Enable hyprpicker";
    };
  };
}
