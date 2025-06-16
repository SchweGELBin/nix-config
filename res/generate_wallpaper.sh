#!/usr/bin/env nix-shell
#!nix-shell -p bash bc ffmpeg inkscape wget -i bash

width=${1:-3440}
height=${2:-1440}
fps=${3:-60}
time=${4:-2}
file=${5:-nixos-wallpaper-catppuccin-mocha.svg}

interval=$(echo "1 / $time" | bc -l)

rm -rf tmp
mkdir tmp

if [ ! -f "$file" ]; then
file=tmp/flake.svg
wget -q https://raw.githubusercontent.com/NixOS/nixos-artwork/51a27e4a011e95cb559e37d32c44cf89b50f5154/wallpapers/nixos-wallpaper-catppuccin-mocha.svg -O "$file"
fi

background="#$(grep 'style="fill:#' < "$file" | cut -d'#' -f2 | cut -d';' -f1)"

inkscape --actions="\
select-by-id:layer1;delete;\
select-by-id:layer2;delete;\
export-filename:tmp/input.svg;\
export-do;" \
"$file"

sed -i "0,/width=\".*\"/{s/width=\".*\"/width=\"$width\"/}" tmp/input.svg
sed -i "0,/height=\".*\"/{s/height=\".*\"/height=\"$height\"/}" tmp/input.svg

for angle in $(LC_NUMERIC="en_US.UTF-8" seq "$interval" "$interval" 60); do
frame=$(echo "$angle * $time" | bc -l)
name="frame_$(printf "%03d" "${frame%.*}").png"
echo "Name: $name; Angle: $angle"

inkscape --actions="\
select-by-id:g4;transform-rotate:$angle;\
select-by-id:g5;transform-rotate:$angle;\
export-background:$background;\
export-filename:tmp/$name;\
export-do;" \
tmp/input.svg

done

ffmpeg -i tmp/frame_%03d.png -lavfi "fps=$fps,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 flake_"$width"x"$height".gif -y

rm -rf tmp
