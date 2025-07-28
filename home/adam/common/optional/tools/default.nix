{
  pkgs,
  ...
}:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      remmina # rdp
      vscodium # vscode
      ;
  };
}
