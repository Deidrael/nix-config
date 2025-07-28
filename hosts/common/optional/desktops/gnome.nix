{
  pkgs,
  ...
}:
{
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  hardware.graphics.enable = true;
  environment.systemPackages = with pkgs; [
    gnomeExtensions.gtile
  ];
}
