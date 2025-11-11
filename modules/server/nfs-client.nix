{
  config,
  lib,
  ...
}:
let
  inherit (config.hostSpec) nfsClient;
in
{
  config = lib.mkIf nfsClient.enable {
    fileSystems =
      let
        makeNFSconfig = share: {
          device = share;
          fsType = "nfs";
          options = nfsClient.options;
        };

        # Create mount points under mountBase for each share name
        mountPoints = builtins.listToAttrs (
          builtins.map (share: {
            name = "${nfsClient.mountBase}/${share}";
            value = "${nfsClient.server}:${share}";
          }) nfsClient.shares
        );
      in
      builtins.mapAttrs (mountPoint: makeNFSconfig) mountPoints;
  };
}
