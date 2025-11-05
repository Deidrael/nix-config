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
    coreutils # basic gnu utils
    curl
    delta
    git
    gitui
    gh
    htop
    p7zip # compression & encryption
    pre-commit # git hooks
    sops
    ssh-to-age
    tmux
    #toybox
    unzip # zip extraction
    vim-full
    wget # downloader

    jq
    #steam-run # for running non-NixOS-packaged binaries on Nix
    yq-go # yaml pretty printer and manipulator
    zip # zip compression
  ];
}
