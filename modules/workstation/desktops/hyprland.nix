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
      power-profiles-daemon.enable = true; # abiilty to switch power profiles
      gnome.gnome-keyring.enable = true; # keyring manager
    };

    environment.systemPackages = with pkgs; [
      brightnessctl # adjust screen brightness
      dunst # notifications
      gvfs # mount backend + trash for Thunar
      hyprpolkitagent # gui applications that request eleveated privileges
      kitty # required for the default Hyprland config
      hyprland-qtutils # qt utility apps/libraries
      hyprpaper # wallpaper management
      hyprshot # screenshot
      loupe # gnome image viewer
      thunar # primary file manager
      thunar-volman # automatic volume management
      xarchiver # lightweight archive manager
      tumbler # thumbnail service for Thunar
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
