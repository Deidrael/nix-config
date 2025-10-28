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

  # list all *.nix recursively (default.nix not required)
  recursivelyImport =
    list:
    let
      inherit (lib) concatMap hasSuffix;
      inherit (builtins) isPath filter readFileType;

      expandIfFolder =
        elem:
        if !isPath elem || readFileType elem != "directory" then
          [ elem ]
        else
          lib.filesystem.listFilesRecursive elem;
    in
    filter
      # Filter out any path that doesn't look like `*.nix`
      (elem: !isPath elem || hasSuffix ".nix" (toString elem))
      # Expand any folder to all the files within it
      (concatMap expandIfFolder list);
}
