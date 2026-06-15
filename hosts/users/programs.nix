# Tools needed on every host for every user (including root)
{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.coreutils # basic gnu utils
    pkgs.curl
    pkgs.p7zip # compression & encryption
    pkgs.rsync
    pkgs.unzip # zip extraction
    pkgs.wget # downloader
    pkgs.zip # zip compression
  ];
}
