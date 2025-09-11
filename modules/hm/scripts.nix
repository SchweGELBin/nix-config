{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.scripts;
  vars = import ../vars.nix;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.writeShellScriptBin "rebuild" ''
        cd ${vars.user.config}
        git add .
        nixos-rebuild switch --flake ./#home
      '')

      (pkgs.writeShellScriptBin "update" ''
        cd ${vars.user.config}
        nix flake update
      '')

      (pkgs.writeShellScriptBin "server-rebuild" ''
        cd ${vars.user.config}
        git add .
        nixos-rebuild switch --flake ./#server
      '')

      (pkgs.writeShellScriptBin "config-reset" ''
        mkdir -p ${vars.user.config}
        case $1 in
        git)
          git clone ${vars.my.repo.git} ${vars.user.config}
        ;;
        https)
          git clone ${vars.my.repo.https} ${vars.user.config}
        ;;
        *)
          git clone ${vars.my.repo.https} --depth 1 ${vars.user.config}
        esac
        chown -R ${vars.user.name} ${vars.user.config}
      '')

      (pkgs.writeShellScriptBin "music" ''
        if [[ ! -z $(pgrep music-instance) || ! -z $(pgrep mpv) ]]; then
          pkill music-instance && pkill mpv
        else
          music-instance
        fi
      '')

      (pkgs.writeShellScriptBin "music-instance" ''
        input="$HOME/Media/Music/play.list"
        while read -r line
        do
          mpv $line --no-video --slang=en
        done < "$input"
      '')

      (pkgs.writeShellScriptBin "loopback" ''
        if [[ $(pactl list | grep module-loopback) ]]; then
          pactl unload-module module-loopback
        else
          pactl load-module module-loopback
        fi
      '')

      (pkgs.writeShellScriptBin "ac" ''
        pkill -x ydotool
        ydotool click 0x80
        ydotool click 0x81
        case $1 in
        l) # Left
          ydotool click -r 50 -D 50 0xC0
        ;;
        r) # Right
          ydotool click -r 100 -D 25 0xC1
        ;;
        esac
      '')

      (pkgs.writeShellScriptBin "userjs2nix" ''
        if [ -z "$1" ]; then
          echo "Usage: $0 [arkenfox/Betterfox/Fastfox/Peskyfox/Securefox/Smoothfox or /path/to/user.js]"
          exit 1
        fi
        tmpfile="/tmp/user-$(date +%s).js"
        case "$1" in
        arkenfox)
          link="https://raw.githubusercontent.com/arkenfox/user.js/refs/heads/master/user.js"
        ;;
        Betterfox)
          link="https://raw.githubusercontent.com/yokoffing/Betterfox/refs/heads/main/user.js"
        ;;
        Fastfox)
          link="https://raw.githubusercontent.com/yokoffing/Betterfox/refs/heads/main/Fastfox.js"
        ;;
        Peskyfox)
          link="https://raw.githubusercontent.com/yokoffing/Betterfox/refs/heads/main/Peskyfox.js"
        ;;
        Securefox)
          link="https://raw.githubusercontent.com/yokoffing/Betterfox/refs/heads/main/Securefox.js"
        ;;
        Smoothfox)
          link="https://raw.githubusercontent.com/yokoffing/Betterfox/refs/heads/main/Smoothfox.js"
        ;;
        *)
          cp $1 $tmpfile
        ;;
        esac
        if [ -n "$link" ]; then wget -q $link -O $tmpfile; fi
        version="$(cat $tmpfile | grep "version:" | grep -oE '[0-9]+')"
        if [ -n "$version" ]; then version=" v$version"; fi
        echo "# $1$version"
        cat $tmpfile | grep "^user_pref(" | sort | sed -e 's/^user_pref(//g' -e 's/);.*/;/g' -e '/_user\.js\.parrot/d' -e 's/, / = /g'
        rm $tmpfile
      '')
    ]
    ++ lib.optionals config.hypr.enable [
      (pkgs.writeShellScriptBin "screenshot" ''
        filename="$(date '+%Y-%m-%d_%H-%M-%S').png"
        scrDir="$HOME/Media/Pictures/Screenshots"
        scrPath="$scrDir/$filename"

        mkdir -p $scrDir

        case $1 in
        d) # Display
          grim -o "$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')" $scrPath | wl-copy
        ;;
        w) # Window
          echo "Window mode not working yet"
        ;;
        r) # Region
          grim -g "$(slurp)" $scrPath | wl-copy
        ;;
        h) # Help
          echo "Usage: $0 <option>"
        	echo "d - Display"
        	echo "w - Window"
        	echo "r - Region"
        	echo "h - Help"
        ;;
        esac

        notify-send "Screenshot taken"
      '')

      (pkgs.writeShellScriptBin "binds" ''
        mod1=$(printf "%-5s" "$(cat .config/hypr/hyprland.conf | grep "\$mod1=" | cut -c 7-)")
        mod2=$(printf "%-5s" "$(cat .config/hypr/hyprland.conf | grep "\$mod2=" | cut -c 7-)")
        mod3=$(printf "%-5s" "$(cat .config/hypr/hyprland.conf | grep "\$mod3=" | cut -c 7-)")
        cat ${vars.user.home}/.config/hypr/hyprland.conf | grep "bindd=" | cut -c 7- | tr -d "," \
        | sed "s|\$mod1|$mod1|g" | sed "s|\$mod2|$mod2|g" | sed "s|\$mod3|$mod3|g"
      '')

      (pkgs.writeShellScriptBin "avabg" ''
        pkill cava
        pkill glava
        if [[ $2 == "t" && ! -z $(pgrep avabg-instance) ]]; then
          pkill avabg-instance
        else
          avabg-instance $1
        fi
      '')

      (pkgs.writeShellScriptBin "avabg-instance" ''
        case $1 in
        c) # Cava
          alacritty --class 'hyprbg' --config-file '${vars.user.home}/.config/alacritty/cava.toml' -e 'cava'
        ;;
        gl) # GLava
          echo "I don't know how to set the class for GLava"
        ;;
        esac
      '')
    ];
  };

  options = {
    scripts.enable = lib.mkEnableOption "Enable Scripts";
  };
}
