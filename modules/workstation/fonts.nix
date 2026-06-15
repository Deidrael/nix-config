{
  config,
  lib,
  pkgs,
  ...
}:
let
  isWorkstation = config.hostSpec.role.type == "workstation";
in
{
  config = lib.mkIf isWorkstation {
    fonts.fontDir.enable = true;
    fonts.packages = [
      pkgs.fira-code
      pkgs.fira-code-symbols
      pkgs.font-awesome
      pkgs.liberation_ttf
      pkgs.nerd-fonts.fira-code
      pkgs.nerd-fonts.hack
      pkgs.nerd-fonts.ubuntu
      pkgs.noto-fonts
      pkgs.noto-fonts-color-emoji
      pkgs.ubuntu-classic
    ];
  };
}
