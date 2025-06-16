#!/usr/bin/env nix-shell
#!nix-shell -p bash bc ffmpeg inkscape wget -i bash

width=${1:-3440}
height=${2:-1440}
fps=${3:-60}
time=${4:-2}
file=${5:-nixos-wallpaper-catppuccin-mocha.svg}

interval=$(echo "1 / $time" | bc -l)

if [ ! -f "$file" ]; then
wget -q https://raw.githubusercontent.com/NixOS/nixos-artwork/51a27e4a011e95cb559e37d32c44cf89b50f5154/wallpapers/nixos-wallpaper-catppuccin-mocha.svg
fi

background=#$(cat $file | grep 'style="fill:#' | cut -d'#' -f2 | cut -d';' -f1)

rm -rf tmp
mkdir tmp

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

ffmpeg -framerate "$fps" -pattern_type glob -i 'tmp/frame_*.png' -c:v libx264 -pix_fmt yuv420p flake_"$width"x"$height"x"$fps".mp4

rm -rf tmp
