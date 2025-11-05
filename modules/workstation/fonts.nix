{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.hostSpec.isWorkstation {
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
      noto-fonts-emoji
      noto-fonts-color-emoji
      ubuntu_font_family
    ];
  };
}
