{
  hostSpec,
  lib,
  pkgs,
  ...
}:
lib.mkIf hostSpec.desktopApps.brave {
  programs.brave = {
    enable = true;
    package = pkgs.unstable.brave;
    commandLineArgs = [
      "--no-default-browser-check"
      "--restore-last-session"
    ];
  };
}
