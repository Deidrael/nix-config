{
  ...
}:
{
  home.file.".config/hypr/monitors.conf" = {
    text = ''
      ################
      ### MONITORS ###
      ################
      # See https://wiki.hypr.land/Configuring/Monitors/
      # hyprctl monitors
      monitor=,preferred,auto,1
      monitor=eDP-1,preferred,0x0,1
      monitor=desc:Acer Technologies XZ342CK TKNAA0013900,highrr,-3440x0,1
      monitor=HDMI-A-5,1920x1080,auto-left,1

      ##############################
      ### WINDOWS AND WORKSPACES ###
      ##############################
      # Ref https://wiki.hypr.land/Configuring/Workspace-Rules/
      workspace = 1, monitor:eDP-1
      workspace = 2, monitor:DP-5

      # See https://wiki.hypr.land/Configuring/Window-Rules/ for more
      # See https://wiki.hypr.land/Configuring/Workspace-Rules/ for workspace rules

      # Example windowrule
      # windowrule = float,class:^(kitty)$,title:^(kitty)$

      # Ignore maximize requests from apps. You'll probably like this.
      windowrule = suppressevent maximize, class:.*

      # Fix some dragging issues with XWayland
      windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
    '';
  };
}
