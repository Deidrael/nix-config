{
  inputs,
  ...
}:
let
  stable-packages = final: prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
      config.nvidia.acceptLicense = true;
      #      overlays = [
      #     ];
    };
  };

  unstable-packages = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
      config.nvidia.acceptLicense = true;
      #      overlays = [
      #     ];
    };
  };

  master-packages = final: prev: {
    master = import inputs.nixpkgs-master {
      system = final.stdenv.hostPlatform.system;
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
