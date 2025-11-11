# Specifications For Differentiating Hosts - thanks to EmergentMind for this config options concept
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
          example = "john";
        };
        primaryUserFullName = lib.mkOption {
          type = lib.types.str;
          description = "The full name of the primary user";
          example = "John Doe";
        };
        handle = lib.mkOption {
          type = lib.types.str;
          description = "The handle of the user, such as a GitHub username";
          example = "jdoe";
        };
        home = lib.mkOption {
          type = lib.types.str;
          default =
            let
              user = config.hostSpec.primaryUsername;
            in
            "/home/${user}";
          description = "The home directory of the primary user (defaults to /home/<primaryUsername>)";
          example = "/home/john";
        };
        email = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = "The email addresses of the user, keyed by purpose";
          example = {
            personal = "user@example.com";
            work = "user@company.com";
          };
        };
        secondaryUsername = lib.mkOption {
          type = lib.types.str;
          description = "The secondary username of the host, if applicable";
          example = "jane";
        };
        secondaryUserFullName = lib.mkOption {
          type = lib.types.str;
          description = "The full name of the secondary user, if applicable";
          example = "Jane Doe";
        };
        ## System information
        hostName = lib.mkOption {
          type = lib.types.str;
          description = "The hostname of the host";
          example = "pc1";
        };
        domain = lib.mkOption {
          type = lib.types.str;
          default = "localdomain";
          description = "The domain of the host";
          example = "example.com";
        };
        fsBtrfs = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether the host uses Btrfs filesystem (set to true for Btrfs-based setups)";
        };
        hasNvidia = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether the host has Nvidia graphics hardware (enables Nvidia-specific configurations)";
        };
        users = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ config.hostSpec.primaryUsername ];
          description = "List of all usernames on the host (defaults to primary username)";
          example = [
            "john"
            "jane"
          ];
        };

        # Configuration Roles
        role = lib.mkOption {
          type = lib.types.submodule {
            options = {
              type = lib.mkOption {
                type = lib.types.enum [
                  "server"
                  "workstation"
                ];
                default = "server";
                description = "The primary role of the host ('server' for headless/server setups, 'workstation' for desktop/laptop)";
                example = "workstation";
              };
              gaming = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to enable gaming features (e.g., Steam, game optimizations)";
              };
            };
          };
          default = { };
          description = "Host role configuration, defining its primary function and features";
          example = {
            type = "workstation";
            gaming = true;
          };
        };

        # Server Software
        podman = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to install and configure Podman for container management";
        };
        ollama = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to install and configure Ollama for AI model serving";
        };

        nfsClient = lib.mkOption {
          type = lib.types.submodule {
            options = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to map NFS shares on this host";
              };
              server = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "The address of the NFS server (required if enable is true)";
                example = "192.168.1.100";
              };
              shares = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "List of NFS share names to map";
                example = [
                  "share1"
                  "share2"
                ];
              };
              mountBase = lib.mkOption {
                type = lib.types.str;
                default = "/mnt/nfs";
                description = "Base directory for NFS mount points";
                example = "/shared";
              };
              options = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [
                  "nfsvers=4.2"
                  "x-systemd.automount"
                  "noauto"
                  "x-systemd.idle-timeout=600"
                ];
                description = "NFS mount options (defaults include on-demand mounting)";
                example = [
                  "nfsvers=4.2"
                  "x-systemd.automount"
                ];
              };
            };
          };
          default = { };
          description = "NFS client configuration";
          example = {
            enable = true;
            server = "nfs.example.com";
            shares = [
              "data"
              "media"
            ];
            mountBase = "/shared";
            options = [
              "nfsvers=4.2"
              "x-systemd.automount"
            ];
          };
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
                description = "The display manager to use for graphical login";
                example = "lightdm";
              };
              hyprland = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Whether to enable Hyprland as a desktop environment";
                };
              };
              gnome = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Whether to enable GNOME as a desktop environment";
                };
              };
              cinnamon = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Whether to enable Cinnamon as a desktop environment";
                };
              };
            };
          };
          default = { };
          description = "Desktop and display configurations for graphical environments";
          example = {
            displayManager = "gdm";
            gnome.enable = true;
          };
        };

        # Unused at this time
        persistFolder = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "The folder to persist data if impermanence is enabled (leave empty if not using impermanence)";
          example = "/persist";
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
        {
          assertion =
            !config.hostSpec.nfsClient.enable
            || (config.hostSpec.nfsClient.server != "" && config.hostSpec.nfsClient.shares != [ ]);
          message = "NFS client is enabled but server is not set or shares list is empty";
        }
      ];
  };
}
