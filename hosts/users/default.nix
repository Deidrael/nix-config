{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (config) hostSpec;
in
{
  imports = [
    ./programs.nix
  ];

  # Import all non-root users
  users = {
    mutableUsers = false; # Required for password to be set via sops during system activation!
    users =
      (lib.mergeAttrsList
        # FIXME: For isMinimal we can likely just filter out primaryUsername only?
        (
          map (user: {
            "${user}" =
              let
                sopsHashedPasswordFile = config.sops.secrets."passwords/${user}".path;
                pubKeys = lib.filesystem.listFilesRecursive (lib.custom.relativeToRoot "hosts/users/${user}/keys/");
                userPubKeys = lib.lists.forEach pubKeys (key: builtins.readFile key);
                userPath = lib.custom.relativeToRoot "hosts/users/${user}/default.nix";
              in
              {
                name = user;
                home = "/home/${user}";
                openssh.authorizedKeys.keys = userPubKeys;
                # Decrypt password to /run/secrets-for-users/ so it can be used to create the user
                hashedPasswordFile = sopsHashedPasswordFile; # Blank if sops isn't working
              }
              # Add in platform-specific user values if they exist
              // lib.optionalAttrs (lib.pathExists userPath) (
                import userPath {
                  inherit config lib;
                }
              );
          }) config.hostSpec.users
        )
      )
      // {
        root = {
          inherit (config.users.users.${config.hostSpec.primaryUsername}) hashedPasswordFile;
          inherit (config.users.users.${config.hostSpec.primaryUsername}) hashedPassword;
          # root's ssh key are mainly used for remote deployment
          openssh.authorizedKeys.keys =
            config.users.users.${config.hostSpec.primaryUsername}.openssh.authorizedKeys.keys;
        };
      };
  };
}
// lib.optionalAttrs (inputs ? "home-manager") {
  home-manager =
    let
      fullPathIfExists =
        path:
        let
          fullPath = lib.custom.relativeToRoot path;
        in
        lib.optional (lib.pathExists fullPath) fullPath;
    in
    {
      extraSpecialArgs = {
        inherit pkgs inputs;
        inherit (config) hostSpec;
      };
      # Add all non-root users to home-manager
      users =
        (lib.mergeAttrsList (
          map (user: {
            "${user}".imports = lib.flatten [
              (map fullPathIfExists [
                "home/${user}/${hostSpec.hostName}.nix"
              ])
              # Static module with common values avoids duplicate file per user
              (_: {
                home = {
                  homeDirectory = "/home/${user}";
                  username = "${user}";
                };
              })
            ];
          }) config.hostSpec.users
        ))
        // {
          root = {
            home.stateVersion = "24.05"; # Avoid error
          };
        };
    };
}
