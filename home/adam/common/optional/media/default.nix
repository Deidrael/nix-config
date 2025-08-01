{
  pkgs,
  ...
}:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      #audacity
      musescore
      ;
    inherit (pkgs.stable)
      audacity
      ;
  };
}
