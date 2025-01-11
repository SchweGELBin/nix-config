{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  vars = import ../nix/vars.nix;
  logo = ".config/logo.png";
  logop = "~/${logo}";
  wall = ".config/background.png";
  wallp = "~/${wall}";
in
{
  config = lib.mkIf config.hypr.enable {

    home.file = {
      "${logo}".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/logos/exports/1544x1544_circle.png";
        hash = "sha256-A85wBdJ2StkgODmxtNGfbNq8PU3G3kqnBAwWvQXVtqo=";
      };
      "${wall}".source = ../../res/wallpaper.png;
    };

    programs = {
      hyprlock = {
        enable = true;
        package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;
        settings = {
          background = [
            {
              blur_passes = 0;
              color = "$base";
              monitor = "";
              path = "${wallp}";
            }
          ];
          general = {
            disable_loading_bar = true;
            hide_cursor = true;
          };
          image = {
            border_color = "$accent";
            halign = "center";
            monitor = "";
            path = "${logop}";
            position = "0, 75";
            size = 100;
            valign = "center";
          };
          input-field = [
            {
              capslock_color = "$yellow";
              check_color = "$accent";
              dots_center = true;
              dots_size = 0.2;
              dots_spacing = 0.2;
              fade_on_empty = false;
              fail_color = "$red";
              fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
              font_color = "$text";
              halign = "center";
              hide_input = false;
              inner_color = "$surface0";
              monitor = "";
              outer_color = "$accent";
              outline_thickness = 4;
              placeholder_text = "<span foreground=\"##$textAlpha\"><i>󰌾 Logged in as </i><span foreground=\"##$accentAlpha\">$USER</span></span>";
              position = "0, -47";
              size = "300, 60";
              valign = "center";
            }
          ];
          label = [
            {
              color = "$text";
              font_family = "$font";
              font_size = 25;
              halign = "left";
              monitor = "";
              position = "30, -30";
              text = "Layout: $LAYOUT";
              valign = "top";
            }
            {
              color = "$text";
              font_family = "$font";
              font_size = 90;
              halign = "right";
              monitor = "";
              position = "-30, 0";
              text = "$TIME";
              valign = "top";
            }
            {
              color = "$text";
              font_family = "$font";
              font_size = 25;
              halign = "right";
              monitor = "";
              position = "-30, -150";
              text = "cmd[update:43200000] date +\"%A, %d %B %Y\"";
              valign = "top";
            }
          ];
        };
      };
    };

    services = {
      hypridle = {
        enable = true;
        package = inputs.hypridle.packages.${pkgs.system}.hypridle;
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
        enable = true;
        package = inputs.hyprpaper.packages.${pkgs.system}.hyprpaper;
        settings = {
          preload = [ "${wallp}" ];
          wallpaper = [ ",${wallp}" ];
        };
      };
    };

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
          "$altMod   SHIFT,  up        ,  Add window to master                          ,  layoutmsg             , addmaster"
          "$mainMod       ,  C         ,  Close active window                           ,  killactive            , "
          "$mainMod       ,  mouse_down,  Go to next workspace                          ,  workspace             , e+1"
          "$mainMod       ,  mouse_up  ,  Go to previous workspace                      ,  workspace             , e-1"
          "$mainMod       ,  0         ,  Go to workspace 0                             ,  workspace             , 0"
          "$mainMod       ,  1         ,  Go to workspace 1                             ,  workspace             , 1"
          "$mainMod       ,  2         ,  Go to workspace 2                             ,  workspace             , 2"
          "$mainMod       ,  3         ,  Go to workspace 3                             ,  workspace             , 3"
          "$mainMod       ,  4         ,  Go to workspace 4                             ,  workspace             , 4"
          "$mainMod       ,  5         ,  Go to workspace 5                             ,  workspace             , 5"
          "$mainMod       ,  6         ,  Go to workspace 6                             ,  workspace             , 6"
          "$mainMod       ,  7         ,  Go to workspace 7                             ,  workspace             , 7"
          "$mainMod       ,  8         ,  Go to workspace 8                             ,  workspace             , 8"
          "$mainMod       ,  9         ,  Go to workspace 9                             ,  workspace             , 9"
          "$mainMod       ,  V         ,  Kill a window (select or exit with [esc])     ,  exec                  , hyprctl kill"
          "$mainMod       ,  RETURN    ,  Launch App Launcher ($applauncher)            ,  exec                  , $applauncher"
          "$mainMod       ,  A         ,  Launch Browser ($browser)                     ,  exec                  , $browser"
          "$mainMod       ,  K         ,  Launch Color Picker                           ,  exec                  , hyprpicker -f hex -a"
          "$mainMod       ,  D         ,  Launch Discord client ($discord)              ,  exec                  , $discord"
          "$mainMod       ,  E         ,  Launch File Manager ($filemanager)            ,  exec                  , $filemanager"
          "$mainMod       ,  R         ,  Launch Rocket League                          ,  exec                  , mangohud legendary launch Sugar"
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
          "$mainMod  SHIFT,  0         ,  Move focused window and go to workspace 0     ,  movetoworkspace       , 0"
          "$mainMod  SHIFT,  1         ,  Move focused window and go to workspace 1     ,  movetoworkspace       , 1"
          "$mainMod  SHIFT,  2         ,  Move focused window and go to workspace 2     ,  movetoworkspace       , 2"
          "$mainMod  SHIFT,  3         ,  Move focused window and go to workspace 3     ,  movetoworkspace       , 3"
          "$mainMod  SHIFT,  4         ,  Move focused window and go to workspace 4     ,  movetoworkspace       , 4"
          "$mainMod  SHIFT,  5         ,  Move focused window and go to workspace 5     ,  movetoworkspace       , 5"
          "$mainMod  SHIFT,  6         ,  Move focused window and go to workspace 6     ,  movetoworkspace       , 6"
          "$mainMod  SHIFT,  7         ,  Move focused window and go to workspace 7     ,  movetoworkspace       , 7"
          "$mainMod  SHIFT,  8         ,  Move focused window and go to workspace 8     ,  movetoworkspace       , 8"
          "$mainMod  SHIFT,  9         ,  Move focused window and go to workspace 9     ,  movetoworkspace       , 9"
          "$mainMod       ,  M         ,  Play Music                                    ,  exec                  , music"
          "$altMod   SHIFT,  down      ,  Remove window from master                     ,  layoutmsg             , removemaster"
          "$mainMod       ,  W         ,  Restart Bar ($bar)                            ,  exec                  , pkill -x $bar && $bar"
          "          SUPER,  ALT_L     ,  Show Keybinds                                 ,  exec                  , kitty --hold binds"
          "$mainMod       ,  grave     ,  Show Workspaces                               ,  hyprexpo:expo         , toggle"
          "$altMod        ,  Tab       ,  Swap focused window with master or first child,  layoutmsg             , swapwithmaster"
          "$altMod        ,  up        ,  Swap focused window with next one             ,  layoutmsg             , swapnext"
          "$altMod        ,  down      ,  Swap focused window with previous one         ,  layoutmsg             , swapprev"
          "               ,  Print     ,  Take Screenshot of current Display            ,  exec                  , screenshot d"
          "$mainMod       ,  Print     ,  Take Screenshot of focused Window             ,  exec                  , screenshot w"
          "          SHIFT,  Print     ,  Take Screenshot of selected Region            ,  exec                  , screenshot r"
          "$mainMod       ,  B         ,  Toggle Cava Background                        ,  exec                  , cavabg t"
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
          blur.new_optimizations = false;
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
          "cavabg"
          "hypridle"
          "hyprpaper"
          "openrgb -c $accentAlpha"
          "waybar"
        ];

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
        };

        master = {
          allow_small_split = true;
          new_status = "inherit";
          orientation = "center";
          slave_count_for_center_master = 3;
        };

        misc = {
          middle_click_paste = false;
          vrr = 1;
        };

        monitor = [
          ",preferred,auto,1" # Default
          "Unknown-1,disable" # Ghost Monitor
          "DP-2,2560x1440@180,0x0,1,bitdepth,10,vrr,1,transform,0" # Main
        ];

        plugin = {
          hyprexpo = {
            columns = 3;
            gap_size = 5;
            bg_col = "$accent";
            workspace_method = "first 1";
          };
          hyprtrails.color = "$accent";
          hyprwinwrap.class = "hyprbg";
        };

        windowrulev2 = [
          "idleinhibit focus, title:^(Rocket League)(.*)"
          "fullscreen, class:^(.*)(.exe)$"
        ];
      };
    };
  };

  options = {
    hypr.enable = lib.mkEnableOption "Enable Hypr";
  };
}
