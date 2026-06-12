# Tools needed on every host for every user (including root)
{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    coreutils # basic gnu utils
    curl
    p7zip # compression & encryption
    rsync
    unzip # zip extraction
    wget # downloader
    zip # zip compression
  ];
}
