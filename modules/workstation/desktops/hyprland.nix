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
      plugins = with pkgs; [
        thunar-archive-plugin # archive context menus (zip/tar)
        thunar-volman # automatic volume management
      ];
    };

    environment.systemPackages = with pkgs; [
      brightnessctl # adjust screen brightness
      dunst # notifications
      hyprpolkitagent # gui applications that request elevated privileges
      kitty # required for the default Hyprland config
      hyprland-qtutils # qt utility apps/libraries
      hyprpaper # wallpaper management
      hyprshot # screenshot
      loupe # gnome image viewer
      xarchiver # lightweight archive manager
      wlogout # power and logoff menu
      wofi # launcher
    ];

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
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
