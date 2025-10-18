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
      name = "desc:AOC Q27G4 18DPCHA026086";
      wall = ".config/background";
      wallp = "~/${monitors.first.wall}";
    };
    second = {
      name = "desc:Acer Technologies XZ342CU V3 A4070C3923W01";
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
      packages = with pkgs; lib.optionals cfg.picker.enable [ hyprpicker ];
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
      settings = {

        "$alt" = "\$${vars.cat.alt}";
        "$applauncher" = "fuzzel";
        "$applauncher2" = "rofi -show drun -show-icons";
        "$bar" = "waybar";
        "$browser" = "firefox";
        "$discord" = "vesktop";
        "$filemanager" = "nemo";
        "$mod1" = "SUPER";
        "$mod2" = "ALT_L";
        "$mod3" = "CtrlR";
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
          "$mod2  SHIFT,  up        ,  Add window to master                          ,  layoutmsg             , addmaster"
          "$mod3       ,  left      ,  Auto Clicker Left                             ,  exec                  , ac l"
          "$mod3       ,  right     ,  Auto Clicker Right                            ,  exec                  , ac r"
          "$mod1       ,  C         ,  Close active window                           ,  killactive            , "
          "$mod1       ,  mouse_down,  Go to next workspace                          ,  workspace             , e+1"
          "$mod1       ,  mouse_up  ,  Go to previous workspace                      ,  workspace             , e-1"
          "$mod1       ,  1         ,  Go to workspace 1                             ,  workspace             , 1"
          "$mod1       ,  KP_Home   ,  Go to workspace 1                             ,  workspace             , 1"
          "$mod1       ,  2         ,  Go to workspace 2                             ,  workspace             , 2"
          "$mod1       ,  KP_Up     ,  Go to workspace 2                             ,  workspace             , 2"
          "$mod1       ,  3         ,  Go to workspace 3                             ,  workspace             , 3"
          "$mod1       ,  KP_Prior  ,  Go to workspace 3                             ,  workspace             , 3"
          "$mod1       ,  4         ,  Go to workspace 4                             ,  workspace             , 4"
          "$mod1       ,  KP_Left   ,  Go to workspace 4                             ,  workspace             , 4"
          "$mod1       ,  5         ,  Go to workspace 5                             ,  workspace             , 5"
          "$mod1       ,  KP_Begin  ,  Go to workspace 5                             ,  workspace             , 5"
          "$mod1       ,  6         ,  Go to workspace 6                             ,  workspace             , 6"
          "$mod1       ,  KP_Right  ,  Go to workspace 6                             ,  workspace             , 6"
          "$mod1       ,  7         ,  Go to workspace 7                             ,  workspace             , 7"
          "$mod1       ,  KP_End    ,  Go to workspace 7                             ,  workspace             , 7"
          "$mod1       ,  8         ,  Go to workspace 8                             ,  workspace             , 8"
          "$mod1       ,  KP_Down   ,  Go to workspace 8                             ,  workspace             , 8"
          "$mod1       ,  9         ,  Go to workspace 9                             ,  workspace             , 9"
          "$mod1       ,  KP_Next   ,  Go to workspace 9                             ,  workspace             , 9"
          "$mod1       ,  V         ,  Kill a window (select or exit with [esc])     ,  exec                  , hyprctl kill"
          "$mod1       ,  RETURN    ,  Launch App Launcher ($applauncher)            ,  exec                  , $applauncher"
          "$mod2       ,  RETURN    ,  Launch App Launcher Alt ($applauncher2)       ,  exec                  , $applauncher2"
          "$mod1       ,  A         ,  Launch Browser ($browser)                     ,  exec                  , $browser"
          "$mod1       ,  KP_Enter  ,  Launch Calculator                             ,  exec                  , rofi -show calc"
          "$mod1       ,  K         ,  Launch Color Picker                           ,  exec                  , hyprpicker -f hex -a"
          "$mod1       ,  D         ,  Launch Discord client ($discord)              ,  exec                  , $discord"
          "$mod1       ,  backslash ,  Launch Emoji Picker                           ,  exec                  , rofi -show emoji"
          "$mod1       ,  E         ,  Launch File Manager ($filemanager)            ,  exec                  , $filemanager"
          "$mod1       ,  escape    ,  Launch Logout Menu                            ,  exec                  , loginctl lock-session"
          "$mod1       ,  backspace ,  Launch Resource Monitor                       ,  exec                  , kitty --hold btop"
          "$mod1       ,  R         ,  Launch Rocket League                          ,  exec                  , DISPLAY= legendary launch Sugar"
          "$mod1       ,  Q         ,  Launch Terminal ($terminal)                   ,  exec                  , $terminal"
          "$mod1  SHIFT,  S         ,  Move current workspace to special workspace   ,  movetoworkspace       , special:magic"
          "$mod1       ,  down      ,  Move focus down                               ,  movefocus             , d"
          "$mod1       ,  left      ,  Move focus left                               ,  movefocus             , l"
          "$mod1       ,  right     ,  Move focus right                              ,  movefocus             , r"
          "$mod1       ,  up        ,  Move focus up                                 ,  movefocus             , u"
          "$mod2       ,  ALT_L     ,  Move focus to master or first child           ,  layoutmsg             , focusmaster"
          "$mod1       ,  Tab       ,  Move focus to next monitor                    ,  focusmonitor          , +1"
          "$mod2       ,  right     ,  Move focus to next window                     ,  layoutmsg             , cyclenext"
          "$mod1  SHIFT,  Tab       ,  Move focus to previous monitor                ,  focusmonitor          , -1"
          "$mod2       ,  left      ,  Move focus to previous window                 ,  layoutmsg             , cycleprev"
          "$mod1  SHIFT,  1         ,  Move focused window and go to workspace 1     ,  movetoworkspace       , 1"
          "$mod1  SHIFT,  KP_Home   ,  Move focused window and go to workspace 1     ,  movetoworkspace       , 1"
          "$mod1  SHIFT,  2         ,  Move focused window and go to workspace 2     ,  movetoworkspace       , 2"
          "$mod1  SHIFT,  KP_Up     ,  Move focused window and go to workspace 2     ,  movetoworkspace       , 2"
          "$mod1  SHIFT,  3         ,  Move focused window and go to workspace 3     ,  movetoworkspace       , 3"
          "$mod1  SHIFT,  KP_Prior  ,  Move focused window and go to workspace 3     ,  movetoworkspace       , 3"
          "$mod1  SHIFT,  4         ,  Move focused window and go to workspace 4     ,  movetoworkspace       , 4"
          "$mod1  SHIFT,  KP_Left   ,  Move focused window and go to workspace 4     ,  movetoworkspace       , 4"
          "$mod1  SHIFT,  5         ,  Move focused window and go to workspace 5     ,  movetoworkspace       , 5"
          "$mod1  SHIFT,  KP_Begin  ,  Move focused window and go to workspace 5     ,  movetoworkspace       , 5"
          "$mod1  SHIFT,  6         ,  Move focused window and go to workspace 6     ,  movetoworkspace       , 6"
          "$mod1  SHIFT,  KP_Right  ,  Move focused window and go to workspace 6     ,  movetoworkspace       , 6"
          "$mod1  SHIFT,  7         ,  Move focused window and go to workspace 7     ,  movetoworkspace       , 7"
          "$mod1  SHIFT,  KP_End    ,  Move focused window and go to workspace 7     ,  movetoworkspace       , 7"
          "$mod1  SHIFT,  8         ,  Move focused window and go to workspace 8     ,  movetoworkspace       , 8"
          "$mod1  SHIFT,  KP_Down   ,  Move focused window and go to workspace 8     ,  movetoworkspace       , 8"
          "$mod1  SHIFT,  9         ,  Move focused window and go to workspace 9     ,  movetoworkspace       , 9"
          "$mod1  SHIFT,  KP_Next   ,  Move focused window and go to workspace 9     ,  movetoworkspace       , 9"
          "$mod1       ,  M         ,  Play Music                                    ,  exec                  , music"
          "$mod2  SHIFT,  down      ,  Remove window from master                     ,  layoutmsg             , removemaster"
          "$mod1       ,  W         ,  Restart Bar ($bar)                            ,  exec                  , pkill $bar && $bar"
          "SUPER       ,  Menu      ,  Show Keybinds                                 ,  exec                  , kitty --hold binds"
          "$mod2       ,  Tab       ,  Swap focused window with master or first child,  layoutmsg             , swapwithmaster"
          "$mod2       ,  up        ,  Swap focused window with next one             ,  layoutmsg             , swapnext"
          "$mod2       ,  down      ,  Swap focused window with previous one         ,  layoutmsg             , swapprev"
          "            ,  Print     ,  Take Screenshot of current Display            ,  exec                  , screenshot d"
          "$mod1       ,  Print     ,  Take Screenshot of focused Window             ,  exec                  , screenshot w"
          "       SHIFT,  Print     ,  Take Screenshot of selected Region            ,  exec                  , screenshot r"
          "$mod1       ,  G         ,  Toggle floating window                        ,  togglefloating        , "
          "$mod1       ,  F         ,  Toggle fullscreen                             ,  fullscreen            , "
          "$mod1       ,  O         ,  Toggle h/w window split                       ,  togglesplit           , "
          "$mod1       ,  P         ,  Toggle pseudo (Keep aspect ratio)             ,  pseudo                , "
          "$mod1       ,  S         ,  Toggle special workspace                      ,  togglespecialworkspace, magic"
        ]
        ++ lib.optionals (cfg.land.plugins.enable && cfg.land.plugins.hyprexpo.enable) [
          "$mod1       ,  grave     ,  Show Workspaces                               ,  hyprexpo:expo         , toggle"
          "$mod1       ,  B         ,  Toggle Cava Background                        ,  exec                  , avabg c t"
          "$mod1  SHIFT,  B         ,  Toggle GLava Background                       ,  exec                  , avabg gl t"
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
          "$mod1, mouse:272, Move Window, movewindow"
          "$mod1, mouse:273, Resize Window, resizewindow"
        ];

        debug = {
          error_position = 1;
        };

        decoration = {
          active_opacity = 0.75;
          blur.new_optimizations = !cfg.land.plugins.hyprexpo.enable;
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
        ++ lib.optionals cfg.paper.enable [ "hyprpaper" ]
        ++ lib.optionals config.waybar.enable [ "waybar" ]
        ++ lib.optionals (cfg.land.plugins.enable && cfg.land.plugins.hyprexpo.enable) [ "avabg c" ];

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
          kb_layout = "us_de, us_de";
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

        # monitorv2 alternative
        # output, mode, position, scale, ...
        monitor = [
          (lib.strings.concatStringsSep "," [
            ""
            "preferred"
            "auto"
            "1"
          ])
          (lib.strings.concatStringsSep "," [
            "Unknown-1"
            "disable"
          ])
          (lib.strings.concatStringsSep "," [
            "${monitors.first.name}"
            "${toString vars.monitors.first.res.x}x${toString vars.monitors.first.res.y}@${toString vars.monitors.first.hz}"
            "0x0"
            "1"
            (lib.strings.optionalString cfg.land.forceBitdepth.enable "bitdepth,${toString vars.monitors.first.bit}")
          ])
          (lib.strings.concatStringsSep "," [
            "${monitors.second.name}"
            "${toString vars.monitors.second.res.x}x${toString vars.monitors.second.res.y}@${toString vars.monitors.second.hz}"
            "${toString vars.monitors.first.res.x}x0"
            "1"
            (lib.strings.optionalString cfg.land.forceBitdepth.enable "bitdepth,${toString vars.monitors.second.bit}")
          ])
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

        # Multiple rules per line: https://github.com/hyprwm/Hyprland/pull/11689
        windowrule = [
          "fullscreen, class:rocketleague.exe"
          "idleinhibit focus, class:rocketleague.exe"
          "monitor 1, class:rocketleague.exe"
          "noscreenshare on, class:Bitwarden"
          "fullscreen, title:Minecraft.*"
        ];
      };
    }
    // lib.optionalAttrs cfg.land.plugins.enable {
      plugins =
        with pkgs.hyprlandPlugins;
        lib.optionals cfg.land.plugins.borders-plus-plus.enable [
          borders-plus-plus
        ]
        ++ lib.optionals cfg.land.plugins.csgo-vulkan-fix.enable [ csgo-vulkan-fix ]
        ++ lib.optionals cfg.land.plugins.hyprbars.enable [ hyprbars ]
        ++ lib.optionals cfg.land.plugins.hyprexpo.enable [ hyprexpo ]
        ++ lib.optionals cfg.land.plugins.hyprfocus.enable [ hyprfocus ]
        ++ lib.optionals cfg.land.plugins.hyprscrolling.enable [ hyprscrolling ]
        ++ lib.optionals cfg.land.plugins.hyprtrails.enable [ hyprtrails ]
        ++ lib.optionals cfg.land.plugins.hyprwinwrap.enable [ hyprwinwrap ]
        ++ lib.optionals cfg.land.plugins.xtra-dispatchers.enable [ xtra-dispatchers ];
    };
  };

  options = {
    hypr = {
      enable = lib.mkEnableOption "Enable Hypr*";
      idle.enable = lib.mkEnableOption "Enable hypridle";
      land = {
        enable = lib.mkEnableOption "Enable Hyprland";
        forceBitdepth.enable = lib.mkEnableOption "Enable forcing monitor bitdepth";
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
