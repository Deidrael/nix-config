# No matter what environment we are in we want these tools for root and the user(s)
{
  pkgs,
  ...
}:
{
  programs.git.enable = true;
  environment.systemPackages = with pkgs; [
    rsync

    # Packages that don't have custom configs go here
    btop # resource monitor
    copyq # clipboard manager
    coreutils # basic gnu utils
    curl
    dust # visual disk usage
    fd # tree style ls
    git
    htop
    jq # json pretty print
    ncdu # TUI disk usage
    fastfetch # system info
    p7zip # compression & encryption
    ripgrep # better grep
    #steam-run # for running non-NixOS-packaged binaries on Nix
    tmux
    #toybox
    tree # cli dir tree viewer
    unzip # zip extraction
    vim-full
    wget # downloader
    zip # zip compression
  ];
}
