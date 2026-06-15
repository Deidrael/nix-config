# Enables Hyprland window manager, related services, and system packages for desktop environments
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.hostSpec.desktop.hyprland.enable {
    programs = {
      hyprland = {
        enable = true; # enable Hyprland
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };
    };

    services = {
      hypridle.enable = true; # idle timer agent
      power-profiles-daemon.enable = true; # ability to switch power profiles
      gnome.gnome-keyring.enable = true; # keyring manager
      gvfs.enable = true; # mount backend + trash for Thunar
      tumbler.enable = true; # thumbnail service for Thunar
    };

    programs.thunar = {
      enable = true;
      plugins = [
        pkgs.thunar-archive-plugin # archive context menus (zip/tar)
        pkgs.thunar-volman # automatic volume management
      ];
    };

    environment.systemPackages = [
      pkgs.brightnessctl # adjust screen brightness
      pkgs.dunst # notifications
      pkgs.hyprpolkitagent # gui applications that request elevated privileges
      pkgs.kitty # required for the default Hyprland config
      pkgs.hyprland-qtutils # qt utility apps/libraries
      pkgs.hyprpaper # wallpaper management
      pkgs.hyprshot # screenshot
      pkgs.swappy # screenshot editor
      pkgs.loupe # gnome image viewer
      pkgs.xarchiver # lightweight archive manager
      pkgs.wlogout # power and logoff menu
      pkgs.wofi # launcher
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        hyprland.default = [
          "hyprland"
          "gtk"
        ];
      };
    };
  };
}
