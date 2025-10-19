# FIXME(lib.custom): Add some stuff from hmajid2301/dotfiles/lib/module/default.nix, as simplifies option declaration
{ lib, ... }:
{
  # use path relative to the root of the project
  relativeToRoot = lib.path.append ../.;

  # list all *.nix and folders (requires default.nix inside)
  scanPaths =
    path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
          (_type == "directory") # include directories
          || (
            (path != "default.nix") # ignore default.nix
            && (lib.strings.hasSuffix ".nix" path) # include .nix files
          )
        ) (builtins.readDir path)
      )
    );

  # list all *.nix recursively
  # let
  #   inherit (lib) concatMap hasSuffix;
  #   inherit (builtins) isPath filter readFileType;

  #   expandIfFolder = elem:
  #     if !isPath elem || readFileType elem != "directory"
  #       then [ elem ]
  #     else lib.filesystem.listFilesRecursive elem;
  # in
  #   list: filter
  #     # Filter out any path that doesn't look like `*.nix`. Don't forget to use
  #     # toString to prevent copying paths to the store unnecessarily
  #     (elem: !isPath elem || hasSuffix ".nix" (toString elem))
  #     # Expand any folder to all the files within it.
  #     (concatMap expandIfFolder list)
}
