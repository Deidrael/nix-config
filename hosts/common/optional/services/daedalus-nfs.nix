{
  ...
}:
{
  fileSystems =
    let
      makeNFSconfig = share: {
        device = share;
        fsType = "nfs";
        options = [
          "nfsvers=4.1"
          "x-systemd.automount"
        ];
      };
    in
    {
      "/share/Container" = makeNFSconfig "10.69.2.10:/Container";
      "/share/DATA" = makeNFSconfig "10.69.2.10:/DATA";
      "/share/Docker" = makeNFSconfig "10.69.2.10:/Docker";
      "/share/Download" = makeNFSconfig "10.69.2.10:/Download";
      "/share/homes" = makeNFSconfig "10.69.2.10:/homes";
      "/share/Media" = makeNFSconfig "10.69.2.10:/Media";
      "/share/Public" = makeNFSconfig "10.69.2.10:/Public";
      "/share/Syncthing" = makeNFSconfig "10.69.2.10:/Syncthing";
      "/share/Web" = makeNFSconfig "10.69.2.10:/Web";
    };
}
