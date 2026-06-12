{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    btop # resource monitor
    dust # visual disk usage
    fd # file finder
    fastfetch # system info
    git
    jq # json pretty print
    ncdu # TUI disk usage
    ripgrep # better grep
    tree # cli dir tree viewer
    vim-full
  ];
}
