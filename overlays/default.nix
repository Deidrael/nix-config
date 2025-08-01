{
  inputs,
  ...
}:
let
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = true;
      config.nvidia.acceptLicense = true;
      #      overlays = [
      #     ];
    };
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
      config.nvidia.acceptLicense = true;
      #      overlays = [
      #     ];
    };
  };

in
{
  default = final: prev: (stable-packages final prev) // (unstable-packages final prev);
}
