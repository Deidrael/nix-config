{
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.btop # resource monitor
    pkgs.dust # visual disk usage
    pkgs.fd # file finder
    pkgs.fastfetch # system info
    pkgs.git
    pkgs.jq # json pretty print
    pkgs.ncdu # TUI disk usage
    pkgs.ripgrep # better grep
    pkgs.tree # cli dir tree viewer
    pkgs.vim-full
  ];
}
