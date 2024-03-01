{config, pkgs, ...}:
{
  home.file.".config/rofi/config.rasi" = {
    text = ''
configuration {
  display-drun: "Applications: ";
  display-run: "Run: ";
  display-window: "Windows: ";
  drun-display-format: "{icon} {name}";
  font: "Fira Code 13";
  modi: "drun,run,window";
  show-icons: true;
  icon-theme: "Papirus";
}

@theme "/dev/null"

* {
  bg: #${config.colorScheme.palette.base00};
  bg2: #${config.colorScheme.palette.base01};
  fg: #${config.colorScheme.palette.base0E};
  fg2: #${config.colorScheme.palette.base0F};
}

window {
  width: 45%;
  border: 3;
  border-color: @fg;
  border-radius: 10;
}

element {
  padding: 12;
  background-color: @bg;
  text-color: @fg2;
}

element selected {
  text-color: @fg;
}

element-text {
  background-color: inherit;
  text-color: inherit;
  vertical-align: 0.5;
}

element-icon {
  size: 30;
}

entry {
  background-color: @bg2;
  padding: 12;
  text-color: @fg;
}

inputbar {
  children: [prompt, entry];
}

listview {
  background-color: @bg;
  columns: 2;
  lines: 6;
}

mainbox {
  background-color: @bg;
  children: [inputbar, listview];
}

prompt {
  enabled: true;
  background-color: @bg2;
  padding: 12 0 0 12;
  text-color: @fg;
}
    '';
  };  
}
