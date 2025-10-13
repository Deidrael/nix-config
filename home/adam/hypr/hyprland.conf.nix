{
  ...
}:
{
  home.file.".config/hypr/hyprland.conf" = {
    text = ''
      # https://wiki.hypr.land/Configuring/
      source = ~/.config/hypr/monitors.conf
      source = ~/.config/hypr/look-feel.conf
      source = ~/.config/hypr/keybindings.conf

      ###################
      ### MY PROGRAMS ###
      ###################
      # See https://wiki.hypr.land/Configuring/Keywords/
      $terminal = kitty
      $fileManager = nautilus
      $menu =  rofi -show combi -combi-modes "window,run,drun,ssh" -modes combi
      $browser = firefox

      #################
      ### AUTOSTART ###
      #################
      # exec-once = $terminal
      # exec-once = nm-applet &
      exec-once = waybar
      #exec-once = hyprpaper
      exec-once = hypridle
      exec-once = $browser
      exec-once = dunst

      ###################
      ### PERMISSIONS ###
      ###################
      # See https://wiki.hypr.land/Configuring/Permissions/
      # Please note permission changes here require a Hyprland restart and are not applied on-the-fly
      # for security reasons

      # ecosystem {
      #   enforce_permissions = 1
      # }

      # permission = /usr/(bin|local/bin)/grim, screencopy, allow
      # permission = /usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland, screencopy, allow
      # permission = /usr/(bin|local/bin)/hyprpm, plugin, allow
    '';
  };
}
