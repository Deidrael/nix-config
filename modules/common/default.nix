# Imports all common modules using scanPaths for shared configurations
{ lib, ... }:
{
  imports = lib.custom.scanPaths ./.;
}
