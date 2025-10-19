{
  inputs,
  pkgs,
  ...
}:
{
  services = {
    xserver = {
      enable = true;
    };
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
  };
  hardware.graphics.enable = true;

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
    brightnessctl # adjust screen brightness
    dunst # notifications
    gnome-keyring # keyring manager
    kdePackages.dolphin # file manager
    kitty # required for the default Hyprland config
    hyprpaper # wallpaper management
    hyprshot # screenshot
    wlogout # power and logoff menu
    wofi # launcher
  ];
}
