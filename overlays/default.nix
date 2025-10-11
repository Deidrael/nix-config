{
  inputs,
  ...
}:
let
  stable-packages = final: prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = true;
      config.nvidia.acceptLicense = true;
      #      overlays = [
      #     ];
    };
  };

  unstable-packages = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
      config.nvidia.acceptLicense = true;
      #      overlays = [
      #     ];
    };
  };

  master-packages = final: prev: {
    master = import inputs.nixpkgs-master {
      inherit (final) system;
      config.allowUnfree = true;
      config.nvidia.acceptLicense = true;
      #      overlays = [
      #     ];
    };
  };

in
{
  default =
    final: prev:
    (stable-packages final prev) // (unstable-packages final prev) // (master-packages final prev);
}
