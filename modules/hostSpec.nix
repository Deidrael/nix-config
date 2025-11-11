# Specifications For Differentiating Hosts - thanks to EmergentMind for module
{
  config,
  lib,
  ...
}:
{
  options.hostSpec = lib.mkOption {
    type = lib.types.submodule {
      freeformType = with lib.types; attrsOf str;
      options = {
        # Data variables that don't dictate configuration settings
        ## User information
        primaryUsername = lib.mkOption {
          type = lib.types.str;
          description = "The primary username of the host";
        };
        primaryUserFullName = lib.mkOption {
          type = lib.types.str;
          description = "The full name of the user";
        };
        handle = lib.mkOption {
          type = lib.types.str;
          description = "The handle of the user (eg: github user)";
        };
        home = lib.mkOption {
          type = lib.types.str;
          default =
            let
              user = config.hostSpec.primaryUsername;
            in
            "/home/${user}";
          description = "The home directory of the user";
        };
        email = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = "The email of the user";
        };
        secondaryUsername = lib.mkOption {
          type = lib.types.str;
          description = "The secondary username of the host";
        };
        secondaryUserFullName = lib.mkOption {
          type = lib.types.str;
          description = "The full name of the user";
        };
        ## System information
        hostName = lib.mkOption {
          type = lib.types.str;
          description = "The hostname of the host";
        };
        domain = lib.mkOption {
          type = lib.types.str;
          default = "localdomain";
          description = "The domain of the host";
        };
        fsBtrfs = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate btrfs is used";
        };
        hasNvidia = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate host has Nvidia graphics";
        };
        users = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ config.hostSpec.primaryUsername ];
          description = "An attribute set of all users on the host";
        };

        # Configuration Roles
        isServer = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate a server host";
        };
        isWorkstation = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate a workstation host";
        };
        isGaming = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate a gaming host";
        };

        # Server Software
        podman = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Installs podman";
        };
        ollama = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Installs ollama";
        };
        mapNFSshares = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate mapping of NFS Shares";
        };
        nfsServer = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "NFS server address";
        };
        nfsShareNames = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "NFS share list to map";
        };

        # Display Configurations
        desktop = lib.mkOption {
          type = lib.types.submodule {
            options = {
              displayManager = lib.mkOption {
                type = lib.types.enum [
                  "sddm"
                  "gdm"
                  "lightdm"
                ];
                default = "sddm";
                description = "The display manager to use";
              };
              hyprland = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Enable Hyprland desktop environment";
                };
              };
              gnome = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Enable GNOME desktop environment";
                };
              };
              cinnamon = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Enable Cinnamon desktop environment";
                };
              };
            };
          };
          default = { };
          description = "Desktop and display configurations";
        };

        # Unused at this time
        persistFolder = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "The folder to persist data if impermenance is enabled";
        };
      };
    };
  };

  config = {
    assertions =
      let
        # We import these options to HM and NixOS, so need to not fail on HM
        isImpermanent =
          config ? "system" && config.system ? "impermanence" && config.system.impermanence.enable;
      in
      [
        {
          assertion = !isImpermanent || (isImpermanent && "${config.hostSpec.persistFolder}" != "");
          message = "config.system.impermanence.enable is true but no persistFolder path is provided";
        }
      ];
  };
}
