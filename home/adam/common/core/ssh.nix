{
  config,
  ...
}:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # Bring in decrypted config
    extraConfig = ''
      UpdateHostKeys ask
    '';

    matchBlocks = {
      "git" = {
        host = "github.com";
        user = "git";
        forwardAgent = true;
        identitiesOnly = true;
        controlMaster = "auto";
        controlPath = "${config.home.homeDirectory}/.ssh/sockets/S.%r@%h:%p";
        controlPersist = "20m";
      };
      "*" = {
        # Avoids infinite hang if control socket connection interrupted. ex: vpn goes down/up
        serverAliveCountMax = 3;
        serverAliveInterval = 5; # 3 * 5s
        hashKnownHosts = true;
        addKeysToAgent = "yes";
      };
    };
  };
  home.file = {
    ".ssh/config.d/.keep".text = "# Managed by Home Manager";
    ".ssh/sockets/.keep".text = "# Managed by Home Manager";
  };
}
