{ ... }:
{
  services = {
    xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      desktopManager.cinnamon.enable = true;
    };
    displayManager.defaultSession = "cinnamon";
  };
  hardware.graphics.enable = true;
}
