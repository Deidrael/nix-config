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
    pkgs.gh # GitHub CLI
    pkgs.git
    pkgs.gitui # TUI git client
    pkgs.jq # json pretty print
    pkgs.just # command runner
    pkgs.lazygit # TUI git client
    pkgs.ncdu # TUI disk usage
    pkgs.ripgrep # better grep
    pkgs.tree # cli dir tree viewer
    pkgs.vim-full
    pkgs.yq-go # YAML processor
  ];
}
