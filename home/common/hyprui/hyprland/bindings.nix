{
  hostSpec,
  lib,
  ...
}:
let
  lua = lib.generators.mkLuaInline;
  bind = key: action: {
    _args = [
      key
      (lua action)
    ];
  };
  bindOpts = key: action: opts: {
    _args = [
      key
      (lua action)
      opts
    ];
  };
  exec = cmd: ''hl.dsp.exec_cmd("${cmd}")'';
  mvws = ws: ''hl.dsp.focus({ workspace = "${ws}"})'';
  mvwd = ws: ''hl.dsp.window.move({ workspace = "${ws}"})'';
  mvwddr = dr: ''hl.dsp.window.move({ direction = "${dr}"})'';
  #fs = mode: ''hl.dsp.window.fullscreen({ mode = "${mode}"})'';
  focusdr = dr: ''hl.dsp.focus({ direction = "${dr}"})'';
in
lib.mkIf hostSpec.desktop.hyprland.enable {
  wayland.windowManager.hyprland.settings = {
    bind = [
      # Launch Applications
      (bind "SUPER + T" (exec "kitty"))
      (bind "SUPER + E" (exec "thunar"))
      (bind "SUPER + R" (exec "wofi --show drun -H 600 -W 800"))
      (bind "SUPER + B" (exec "firefox"))
      (bind "SUPER + L" (exec "hyprlock"))

      # Screenshots
      (bind "Print" (
        exec "bash -c 'd=\\\"$HOME/Pictures/Screenshots\\\"; f=$(date +%Y-%m-%d-%H%M%S)_hyprshot; hyprshot -m region -o \\\"$d\\\" -f \\\"$f.png\\\" && swappy -f \\\"$d/$f.png\\\"'"
      ))
      (bind "ALT + Print" (
        exec "bash -c 'd=\\\"$HOME/Pictures/Screenshots\\\"; f=$(date +%Y-%m-%d-%H%M%S)_hyprshot; hyprshot -m window -o \\\"$d\\\" -f \\\"$f.png\\\" && swappy -f \\\"$d/$f.png\\\"'"
      ))

      # Window actions
      (bind "SUPER + C" "hl.dsp.window.close()")
      (bind "SUPER + SHIFT + C" "hl.dsp.window.kill()")
      (bind "SUPER + M" "hl.dsp.exit()")
      (bind "SUPER + F" "hl.dsp.window.float({})")
      (bind "SUPER + J" "hl.dsp.layout(\"togglesplit\")") # dwindle

      # Move focus with mainMod + arrow keys
      (bind "SUPER + left" (focusdr "left"))
      (bind "SUPER + right" (focusdr "right"))
      (bind "SUPER + up" (focusdr "up"))
      (bind "SUPER + down" (focusdr "down"))

      # Move window with mainMod + shift + arrow keys
      (bind "SUPER + SHIFT + left" (mvwddr "left"))
      (bind "SUPER + SHIFT + right" (mvwddr "right"))
      (bind "SUPER + SHIFT + up" (mvwddr "up"))
      (bind "SUPER + SHIFT + down" (mvwddr "down"))

      # Switch workspaces with mainMod + [0-9]
      (bind "SUPER + 1" (mvws "1"))
      (bind "SUPER + 2" (mvws "2"))
      (bind "SUPER + 3" (mvws "3"))
      (bind "SUPER + 4" (mvws "4"))
      (bind "SUPER + 5" (mvws "5"))
      (bind "SUPER + 6" (mvws "6"))
      (bind "SUPER + 7" (mvws "7"))
      (bind "SUPER + 8" (mvws "8"))
      (bind "SUPER + 9" (mvws "9"))
      (bind "SUPER + 0" (mvws "10"))

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      (bind "SUPER + SHIFT + 1" (mvwd "1"))
      (bind "SUPER + SHIFT + 2" (mvwd "2"))
      (bind "SUPER + SHIFT + 3" (mvwd "3"))
      (bind "SUPER + SHIFT + 4" (mvwd "4"))
      (bind "SUPER + SHIFT + 5" (mvwd "5"))
      (bind "SUPER + SHIFT + 6" (mvwd "6"))
      (bind "SUPER + SHIFT + 7" (mvwd "7"))
      (bind "SUPER + SHIFT + 8" (mvwd "8"))
      (bind "SUPER + SHIFT + 9" (mvwd "9"))
      (bind "SUPER + SHIFT + 0" (mvwd "10"))

      # Example special workspace (scratchpad)
      (bind "SUPER + S" "hl.dsp.workspace.toggle_special(\"magic\")")
      (bind "SUPER + SHIFT + S" (mvwd "special:magic"))

      # Scroll through existing workspaces with mainMod + scroll
      (bind "SUPER + mouse_down" (mvws "e+1"))
      (bind "SUPER + mouse_up" (mvws "e-1"))

      # Move/resize windows with mainMod + LMB/RMB and dragging
      (bind "SUPER + mouse:272" "hl.dsp.window.drag()")
      (bind "SUPER + mouse:273" "hl.dsp.window.resize()")

      # Laptop multimedia keys for volume and LCD brightness
      # (old bindel: repeat on hold + active while locked)
      (bindOpts "XF86AudioRaiseVolume" (exec "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+") {
        repeating = true;
        locked = true;
      })
      (bindOpts "code:76" (exec "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+") {
        repeating = true;
        locked = true;
      })
      (bindOpts "XF86AudioLowerVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") {
        repeating = true;
        locked = true;
      })
      (bindOpts "code:75" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") {
        repeating = true;
        locked = true;
      })
      (bindOpts "XF86AudioMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") {
        repeating = true;
        locked = true;
      })
      (bindOpts "code:74" (exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") {
        repeating = true;
        locked = true;
      })
      (bindOpts "XF86AudioMicMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle") {
        repeating = true;
        locked = true;
      })
      (bindOpts "XF86MonBrightnessUp" (exec "brightnessctl -e4 -n2 set 5%+") {
        repeating = true;
        locked = true;
      })
      (bindOpts "code:73" (exec "brightnessctl -e4 -n2 set 5%+") {
        repeating = true;
        locked = true;
      })
      (bindOpts "XF86MonBrightnessDown" (exec "brightnessctl -e4 -n2 set 5%-") {
        repeating = true;
        locked = true;
      })
      (bindOpts "code:72" (exec "brightnessctl -e4 -n2 set 5%-") {
        repeating = true;
        locked = true;
      })

      # Requires playerctl (old bindl: active while locked)
      (bindOpts "XF86AudioNext" (exec "playerctl next") { locked = true; })
      (bindOpts "XF86AudioPause" (exec "playerctl play-pause") { locked = true; })
      (bindOpts "XF86AudioPlay" (exec "playerctl play-pause") { locked = true; })
      (bindOpts "XF86AudioPrev" (exec "playerctl previous") { locked = true; })
    ];
  };
}
