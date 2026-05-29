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
    };
  };

  unstable-packages = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
      config.nvidia.acceptLicense = true;
    };
  };

  master-packages = final: prev: {
    master = import inputs.nixpkgs-master {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
      config.nvidia.acceptLicense = true;
    };
  };

  openldap-fix = final: prev: {
    openldap = prev.openldap.overrideAttrs {
      doCheck = !prev.stdenv.hostPlatform.isi686;
    };
  };

  termite-stub = final: prev: {
    termite =
      final.runCommand "termite-removed"
        {
          outputs = [
            "out"
            "terminfo"
          ];
        }
        ''
          mkdir -p $terminfo/share/terminfo $out
        '';
  };

in
{
  default =
    final: prev:
    (stable-packages final prev)
    // (unstable-packages final prev)
    // (master-packages final prev)
    // (openldap-fix final prev)
    // (termite-stub final prev);
}
