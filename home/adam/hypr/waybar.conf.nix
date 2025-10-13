{
  ...
}:
{
  home.file.".config/waybar/config.jsonc" = {
    text = ''
      // -*- mode: jsonc -*-
      {
          // "layer": "top", // Waybar at top layer
          // "position": "top", // Waybar position (top|bottom|left|right)
          "height": 38, // Waybar height (to be removed for auto height)
          // "width": 1280, // Waybar width
          "spacing": 4, // Gaps between modules (4px)
          // Choose the order of the modules
          "modules-left": [
              "hyprland/workspaces",
              "wlr/taskbar"
          ],
          "modules-center": [
              "hyprland/window"
          ],
          "modules-right": [
              "idle_inhibitor",
              "pulseaudio",
              "network",
              "power-profiles-daemon",
              "cpu",
              "memory",
              "temperature",
              "backlight",
              "keyboard-state",
              "battery",
              "clock",
              "tray",
              "custom/power"
          ],
          //////////////////////////////////
          //  Left Modules configuration  //
          //////////////////////////////////
          "hyprland/workspaces": {
              "disable-scroll": true,
              "all-outputs": true,
              "warp-on-scroll": false,
              "format": "{name}: {icon}",
              "format-icons": {
                  "urgent": "",
                  "active": "",
                  "default": ""
              }
          },
          "wlr/taskbar": {
              "format": "{icon} {title:.17}",
              "icon-size": 28,
              "spacing": 3,
              "on-click-middle": "close",
              "tooltip-format": "{title}",
              "ignore-list": [],
              "on-click": "activate"
          },
          //////////////////////////////////
          // Center Modules configuration //
          //////////////////////////////////

          //////////////////////////////////
          // Right Modules configuration  //
          //////////////////////////////////
          "idle_inhibitor": {
              "format": "Anti-idle {icon}",
              "format-icons": {
                  "activated": "",
                  "deactivated": ""
              }
          },
          "pulseaudio": {
              // "scroll-step": 1, // %, can be a float
              "format": "{volume}% {icon} {format_source}",
              "format-bluetooth": "{volume}% {icon} {format_source}",
              "format-bluetooth-muted": " {icon} {format_source}",
              "format-muted": " {format_source}",
              "format-source": "{volume}% ",
              "format-source-muted": "",
              "format-icons": {
                  "headphone": "",
                  "hands-free": "",
                  "headset": "",
                  "phone": "",
                  "portable": "",
                  "car": "",
                  "default": ["", "", ""]
              },
              "on-click": "pavucontrol"
          },
          "network": {
              // "interface": "wlp2*", // (Optional) To force the use of this interface
              "format-wifi": "{essid} ({signalStrength}%) ",
              "format-ethernet": "{ipaddr}/{cidr} ",
              "tooltip-format": "{ifname} via {gwaddr} ",
              "format-linked": "{ifname} (No IP) ",
              "format-disconnected": "Disconnected ⚠",
              "format-alt": "{ifname}: {ipaddr}/{cidr}"
          },
          "power-profiles-daemon": {
            "format": "{icon}",
            "tooltip-format": "Power profile: {profile}\nDriver: {driver}",
            "tooltip": true,
            "format-icons": {
              "default": "",
              "performance": "",
              "balanced": "",
              "power-saver": ""
            }
          },
          "cpu": {
              "format": "{usage}% ",
              "tooltip": false
          },
          "memory": {
              "format": "{}% "
          },
          "temperature": {
              // "thermal-zone": 2,
              // "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
              "critical-threshold": 80,
              // "format-critical": "{temperatureC}°C {icon}",
              "format": "{temperatureC}°C {icon}",
              "format-icons": ["", "", ""]
          },
          "backlight": {
              // "device": "acpi_video1",
              "format": "{percent}% {icon}",
              "format-icons": ["", "", "", "", "", "", "", "", ""]
          },
          "keyboard-state": {
              "numlock": true,
              "capslock": true,
              "format": "{name} {icon}",
              "format-icons": {
                  "locked": "",
                  "unlocked": ""
              }
          },
          "battery": {
              "states": {
                  // "good": 95,
                  "warning": 30,
                  "critical": 15
              },
              "format": "{capacity}% {icon}",
              "format-full": "{capacity}% {icon}",
              "format-charging": "{capacity}% ",
              "format-plugged": "{capacity}% ",
              "format-alt": "{time} {icon}",
              // "format-good": "", // An empty format will hide the module
              // "format-full": "",
              // "format-icons": ["", "", "", "", ""] // horizontal
        "format-icons": ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"] // vertical
          },
          "clock": {
              // "timezone": "America/New_York",
              "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
              "format": "     {:%R\n %m-%d-%Y}",
              "calendar": {
                  "mode": "year",
                  "mode-mon-col": 3,
                  "on-scroll": 1,
                  "on-click-right": "mode",
                  "format": {
                      "months": "<span color='#ffead3'><b>{}</b></span>",
                      "days": "<span color='#ecc6d9'><b>{}</b></span>",
                      "weekdays": "<span color='#ffcc66'><b>{}</b></span>",
                      "today": "<span color='#ff6699'><b><u>{}</u></b></span>"
                  }
              },
              "actions": {
                  "on-click-right": "mode",
                  "on-click-forward": "tz_up",
                  "on-click-backward": "tz_down",
                  "on-scroll-up": "shift_up",
                  "on-scroll-down": "shift_down"
              }
          },
          "tray": {
              // "icon-size": 21,
              "spacing": 10
              // "icons": {
              //   "blueman": "bluetooth",
              //   "TelegramDesktop": "$HOME/.local/share/icons/hicolor/16x16/apps/telegram.png"
              // }
          },
          "custom/power": {
              "format" : "⏻ ",
          "tooltip": false,
          "menu": "on-click",
          "menu-file": "~/.config/waybar/power_menu.xml",
          "menu-actions": {
                  "logout": "loginctl terminate-user $USER",
                  "suspend": "systemctl suspend",
            "hibernate": "systemctl hibernate",
            "reboot": "reboot",
            "shutdown": "shutdown"
          }
          }
      }
    '';
  };

  home.file.".config/waybar/power_menu.xml" = {
    text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <interface>
        <object class="GtkMenu" id="menu">
          <child>
            <object class="GtkMenuItem" id="logout">
              <property name="label">Logout</property>
            </object>
          </child>
          <child>
            <object class="GtkSeparatorMenuItem" id="delimiter0"/>
          </child>
          <child>
            <object class="GtkMenuItem" id="suspend">
              <property name="label">Suspend</property>
            </object>
          </child>
          <child>
            <object class="GtkMenuItem" id="hibernate">
              <property name="label">Hibernate</property>
            </object>
          </child>
          <child>
            <object class="GtkSeparatorMenuItem" id="delimiter1"/>
          </child>
          <child>
            <object class="GtkMenuItem" id="reboot">
              <property name="label">Reboot</property>
            </object>
          </child>
          <child>
            <object class="GtkMenuItem" id="shutdown">
              <property name="label">Shutdown</property>
            </object>
          </child>
        </object>
      </interface>
    '';
  };
}
