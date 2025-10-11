{
  inputs,
  pkgs,
  ...
}:
{
  programs = {
    hyprland = {
      enable = true; # enable Hyprland
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
    hyprlock.enable = true; # lock screen
    waybar.enable = true; # status bar
  };

  services = {
    hypridle.enable = true; # idle timer agent
  };

  environment.systemPackages = with pkgs; [
    kitty # required for the default Hyprland config
    rofi # launcher
    kdePackages.dolphin # file manager
    hyprpaper # wallpaper management
    hyprshot # screenshot
    dunst # notifications
  ];
}
