# Imports workstation-specific modules for desktop, gaming, and hardware features
{
  lib,
  ...
}:
{
  imports = lib.custom.scanPaths ./.;
}
