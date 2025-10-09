# Reminder that CUPS cpanel defaults to localhost:631

{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
    #logging = "debug";
  };

  # Mitigate cups and avahi security issues
  services.printing.browsed.enable = false;

  # Adding my home printer
  hardware.printers = {
    ensureDefaultPrinter = "HP_LaserJet_MFP_M234dw";
    ensurePrinters = [
      {
        name = "HP_M234dw";
        location = "Home";
        deviceUri = "ipp://10.69.3.50/ipp/print";
        model = "HP/hp-laserjet_mfp_m232-m237.ppd.gz";
      }
    ];
  };
}
