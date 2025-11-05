{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.hostSpec.mapNFSshares {
    fileSystems =
      let
        makeNFSconfig = share: {
          device = share;
          fsType = "nfs";
          options = [
            "nfsvers=4.2"
            "x-systemd.automount"
            "noauto"
            "x-systemd.idle-timeout=600"
          ];
        };

        inherit (config.hostSpec) nfsServer;
        inherit (config.hostSpec) nfsShareNames;

        shares = builtins.listToAttrs (
          builtins.map (name: {
            name = "/share/${name}";
            value = "${nfsServer}:${name}";
          }) nfsShareNames
        );
      in
      builtins.mapAttrs (mountPoint: makeNFSconfig) shares;
  };
}
