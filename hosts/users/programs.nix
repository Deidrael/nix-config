# No matter what environment we are in we want these tools for root and the user(s)
{
  pkgs,
  ...
}:
{
  programs.git.enable = true;
  environment.systemPackages = with pkgs; [
    just
    rsync

    # Packages that don't have custom configs go here
    age
    btop # resource monitor
    cachix
    copyq # clipboard manager
    coreutils # basic gnu utils
    curl
    delta
    fd # tree style ls
    git
    gitui
    gh
    htop
    jq # json pretty print
    ncdu # TUI disk usage
    neofetch # system info
    p7zip # compression & encryption
    pre-commit # git hooks
    ripgrep # better grep
    sops
    ssh-to-age
    #steam-run # for running non-NixOS-packaged binaries on Nix
    tmux
    #toybox
    tree # cli dir tree viewer
    unzip # zip extraction
    vim-full
    wget # downloader
    yq-go # yaml pretty printer and manipulator
    zip # zip compression
  ];
}
