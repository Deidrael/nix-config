{ ... }:
{
  nix.settings = {
    substituters = [
      "https://deidrael.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "deidrael.cachix.org-1:73m+qt2qGNI8fhTuM0qwDM3QQM6WdGLxELwucd3+JdA="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
