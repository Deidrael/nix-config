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
    fonts.packages = with pkgs; [
      fira-code
      fira-code-symbols
      font-awesome
      liberation_ttf
      nerd-fonts.fira-code
      nerd-fonts.hack
      nerd-fonts.ubuntu
      noto-fonts
      noto-fonts-color-emoji
      ubuntu-classic
    ];
  };
}
