{ inputs, pkgs, ... }:
let
  vars = import ../nix/vars.nix;
in
{
  programs.waybar = {
    enable = true;
    package = inputs.waybar.packages.${pkgs.system}.waybar;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        margin-bottom = 0;
        margin-left = 0;
        margin-right = 0;
        spacing = 0;
        height = 30;

        modules-left = [
          "custom/logout"
          "hyprland/workspaces"
          "custom/mpv"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "cpu"
          "memory"
          "temperature"
          "pulseaudio"
          "clock"
        ];

        "hyprland/workspaces" = {
          all-outputs = true;
          on-click = "activate";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "󰈹";
            "3" = "";
            "4" = "";
            "5" = "󰙯";
            urgent = "";
            focused = "";
            default = "";
          };
        };

        "hyprland/window" = {
          max-length = 200;
          separate-outputs = true;
        };

        tray = {
          spacing = 10;
        };

        clock = {
          timezone = "Europe/Berlin";
          tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%d-%m-%Y}";
        };

        cpu = {
          format = "{usage}% ";
          tooltip = true;
        };

        memory = {
          format = "{}% ";
        };

        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [
            ""
            ""
            ""
          ];
        };

        pulseaudio = {
          scroll-step = 1;
          format = "{volume} {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = " {volume} ";
          format-source-muted = "";
          format-icons = [
            ""
            ""
            ""
          ];
          on-click = "pavucontrol";
        };

        "custom/logout" = {
          format = "⏻";
          on-click = "wlogout";
        };

        "custom/mpv" = {
          exec = "pactl list sink-inputs | grep \"media.name.*mpv\" | cut -c17- | rev | cut -c8- | rev";
          format = "{}";
          interval = 10;
        };
      };
    };
    style = ''
      /* Waybar */
      * {
          font-family: "DejaVu Sans";
          font-size: 14px;
          border: none;
          border-radius: 0;
      }

      window#waybar {
          color: @text; 
          background-color: transparent;
          transition-property: background-color;
          transition-duration: .5s;
      }

      /* Modules */
      #clock, #cpu, #custom-logout, #custom-mpv, #memory, #pulseaudio, #temperature, #window, #workspaces {
          background: alpha(@base, 0.7);
          border: 2px solid @${vars.cat.accent};
          border-radius: 40px 25px;
          margin: 0 2px;
          padding: 2px 12px;
      }
      #waybar.empty #window {
          background: none;
          border: none;
      }

      /* Workspaces */
      #workspaces button {
          color: @text;
          padding: 0 6px;
          transition: none;
      }
      #workspaces button.active {
          box-shadow: inset 0 -2px @text;
      }
      button:hover { 
          box-shadow: inset 0 -2px @text;
      }

      /* Edges */
      .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
      }
      .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
      }
    '';
    systemd.enable = false;
  };
}
