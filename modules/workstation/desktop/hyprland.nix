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
      # hyprlock.enable = true; # lock screen
      # waybar.enable = true; # status bar
    };

    services = {
      hypridle.enable = true; # idle timer agent
      power-profiles-daemon.enable = true; # abiilty to switch power profiles
      gnome.gnome-keyring.enable = true; # keyring manager
    };

    environment.systemPackages = with pkgs; [
      brightnessctl # adjust screen brightness
      dunst # notifications
      hyprpolkitagent # gui applications that request eleveated privileges
      kdePackages.dolphin # file manager
      kitty # required for the default Hyprland config
      hyprland-qtutils # qt utility apps/libraries
      hyprpaper # wallpaper management
      hyprshot # screenshot
      loupe # gnome image viewer
      wlogout # power and logoff menu
      wofi # launcher
    ];
  };
}
