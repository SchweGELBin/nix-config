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
      (pkgs.writeShellScriptBin "bluetooth-toggle" ''
        if bluetoothctl show | grep "Powered: yes" -q; then
          bluetoothctl power off
        else
          bluetoothctl power on
        fi
      '')
      (pkgs.writeShellScriptBin "config-reset" ''
        rm -rf "${vars.user.config}"
        mkdir -p "${vars.user.config}"
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
      (pkgs.writeShellScriptBin "loopback" ''
        if [[ $(pactl list | grep module-loopback) ]]; then
          pactl unload-module module-loopback
        else
          pactl load-module module-loopback
        fi
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
      (pkgs.writeShellScriptBin "rebuild" ''
        cd ${vars.user.config}
        git add .
        nixos-rebuild switch --flake ./#home
      '')
      (pkgs.writeShellScriptBin "server-rebuild" ''
        cd ${vars.user.config}
        git add .
        nixos-rebuild switch --flake ./#server
      '')
      (pkgs.writeShellScriptBin "update" ''
        cd ${vars.user.config}
        nix flake update
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
      (pkgs.writeShellScriptBin "vpn" ''
        case $1 in
        on)
          systemctl start wg-quick-wg.service
        ;;
        off)
          systemctl stop wg-quick-wg.service
        ;;
        *)
          systemctl restart wg-quick-wg.service
        esac
      '')
    ]
    ++ lib.optionals config.hypr.enable [
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
        c() { alacritty --class 'hyprbg' --config-file '${vars.user.home}/.config/alacritty/cava.toml' -e 'cava'; }
        gl() { glavabg-setup && glava; }
        case $1 in
          c) c;;      # Cava
          gl) gl;;    # GLava
          *) c & gl;; # All
        esac
      '')
      (pkgs.writeShellScriptBin "binds" ''
        mod1=$(printf "%-5s" "$(cat .config/hypr/hyprland.conf | grep "\$mod1=" | cut -c 7-)")
        mod2=$(printf "%-5s" "$(cat .config/hypr/hyprland.conf | grep "\$mod2=" | cut -c 7-)")
        mod3=$(printf "%-5s" "$(cat .config/hypr/hyprland.conf | grep "\$mod3=" | cut -c 7-)")
        cat ${vars.user.home}/.config/hypr/hyprland.conf | grep "bindd=" | cut -c 7- | tr -d "," \
        | sed "s|\$mod1|$mod1|g" | sed "s|\$mod2|$mod2|g" | sed "s|\$mod3|$mod3|g"
      '')
      (
        let
          palette = (lib.importJSON "${pkgs.catppuccin}/palette/palette.json").${vars.cat.flavor}.colors;
          bars = palette.${vars.cat.accent}.hex;
          outline = palette.${vars.cat.alt}.hex;
        in
        pkgs.writeShellScriptBin "glavabg-setup" ''
          cfgdir="${vars.user.home}/.config/glava"
          if [[ -d $cfgdir && $1 == "f" ]]; then rm -r $cfgdir; fi
          if [[ ! -d $cfgdir ]]; then
            glava --copy-config
            sed -i \
              -e 's/#request mod bars/#request mod circle/' \
              -e 's/#request setgeometry 0 0 800 600/#request setgeometry 0 0 2560 1440/' \
              -e 's/#request settitle "GLava"/#request settitle "hyprbg"/' \
              "$cfgdir/rc.glsl"
            sed -i \
              -e 's/#define BAR_OUTLINE #262626/#define BAR_OUTLINE ${outline}/' \
              -e 's/#define COLOR (#3366b2 \* GRADIENT)/#define COLOR ${bars}/' \
              "$cfgdir/bars.glsl"
            sed -i \
              -e 's/#define C_LINE 1.5/#define C_LINE 4/' \
              -e 's/#define C_RADIUS 128/#define C_RADIUS 256/' \
              -e 's/#define OUTLINE #333333/#define OUTLINE ${outline}/' \
              "$cfgdir/circle.glsl"
            sed -i \
              -e 's/#define COLOR mix(#802A2A, #4F4F92, clamp(pos \/ GRADIENT_SCALE, 0, 1))/#define COLOR ${bars}/' \
              -e 's/#define OUTLINE #262626/#define OUTLINE ${outline}/' \
              "$cfgdir/graph.glsl"
            sed -i \
              -e 's/#define C_LINE 2/#define C_LINE 4/' \
              -e 's/#define C_RADIUS 128/#define C_RADIUS 256/' \
              -e 's/#define OUTLINE #333333/#define OUTLINE ${outline}/' \
              "$cfgdir/radial.glsl"
            sed -i \
              -e 's/#define BASE_COLOR vec4(0.7, 0.2, 0.45, 1)/#define BASE_COLOR ${bars}/' \
              -e 's/#define OUTLINE vec4(0.15, 0.15, 0.15, 1)/#define OUTLINE ${outline}/' \
              "$cfgdir/wave.glsl"
          fi
        ''
      )
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
    ];
  };

  options = {
    scripts.enable = lib.mkEnableOption "Enable Scripts";
  };
}
