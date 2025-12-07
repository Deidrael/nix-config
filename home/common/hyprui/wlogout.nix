{
  hostSpec,
  lib,
  ...
}:
lib.mkIf (hostSpec.desktop.hyprland.enable) {
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "loginctl lock-session";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
    # style = ''
    #   * {
    #   	background-image: none;
    #   	box-shadow: none;
    #   }

    #   window {
    #   	background-color: rgba(12, 12, 12, 0.9);
    #   }

    #   button {
    #       border-radius: 0;
    #       border-color: black;
    #   	text-decoration-color: #FFFFFF;
    #       color: #FFFFFF;
    #   	background-color: #1E1E1E;
    #   	border-style: solid;
    #   	border-width: 1px;
    #   	background-repeat: no-repeat;
    #   	background-position: center;
    #   	background-size: 25%;
    #   }

    #   button:focus, button:active, button:hover {
    #   	background-color: #3700B3;
    #   	outline-style: none;
    #   }

    #   #lock {
    #       background-image: image(url("icons/lock.png"), url("/usr/local/share/wlogout/icons/lock.png"));
    #   }

    #   #logout {
    #       background-image: image(url("icons/logout.png"), url("/usr/local/share/wlogout/icons/logout.png"));
    #   }

    #   #suspend {
    #       background-image: image(url("icons/suspend.png"), url("/usr/local/share/wlogout/icons/suspend.png"));
    #   }

    #   #hibernate {
    #       background-image: image(url("icons/hibernate.png"), url("/usr/local/share/wlogout/icons/hibernate.png"));
    #   }

    #   #shutdown {
    #       background-image: image(url("icons/shutdown.png"), url("/usr/local/share/wlogout/icons/shutdown.png"));
    #   }

    #   #reboot {
    #       background-image: image(url("icons/reboot.png"), url("/usr/local/share/wlogout/icons/reboot.png"));
    #         }
    # '';
  };
}
