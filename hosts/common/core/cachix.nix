{ ... }:
{
  nix.settings = {
    substituters = [
      "https://deidrael.cachix.org"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "deidrael.cachix.org-1:73m+qt2qGNI8fhTuM0qwDM3QQM6WdGLxELwucd3+JdA="
    ];
  };
}
