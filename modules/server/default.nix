# Imports server modules for services like NFS, Ollama, and Podman
{ lib, ... }:
{
  imports = lib.custom.scanPaths ./.;
}
