# Specifications For Differentiating Hosts - thanks to EmergentMind for this config options concept
{
  config,
  lib,
  ...
}:
{
  options.hostSpec = lib.mkOption {
    type = lib.types.submodule {
      options = {
        # Data variables that don't dictate configuration settings
        ## User information
        users = lib.mkOption {
          type = lib.types.submodule {
            options = {
              primary = lib.mkOption {
                type = lib.types.submodule {
                  options = {
                    username = lib.mkOption {
                      type = lib.types.str;
                      description = "The primary username of the host";
                      example = "john";
                    };
                    fullName = lib.mkOption {
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
                      default = "/home/${config.hostSpec.users.primary.username}";
                      description = "The home directory of the primary user";
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
                  };
                };
              };
              secondary = lib.mkOption {
                type = lib.types.submodule {
                  options = {
                    enable = lib.mkOption {
                      type = lib.types.bool;
                      default = false;
                      description = "Whether to enable the secondary user";
                    };
                    username = lib.mkOption {
                      type = lib.types.str;
                      description = "The secondary username of the host";
                      example = "jane";
                    };
                    fullName = lib.mkOption {
                      type = lib.types.str;
                      description = "The full name of the secondary user";
                      example = "Jane Doe";
                    };
                    home = lib.mkOption {
                      type = lib.types.str;
                      default = "/home/${config.hostSpec.users.secondary.username}";
                      description = "The home directory of the secondary user";
                      example = "/home/jane";
                    };
                  };
                };
              };
              users = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [
                  config.hostSpec.users.primary.username
                ]
                ++ lib.optional config.hostSpec.users.secondary.enable config.hostSpec.users.secondary.username;
                description = "List of all usernames on the host (defaults to primary username, includes secondary if enabled)";
                example = [
                  "john"
                  "jane"
                ];
              };
            };
          };
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
        hasNvidiaPrime = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether the host has an NVIDIA Optimus/Prime dual-GPU setup (iGPU + dGPU with dynamic switching)";
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
        aiTools = lib.mkOption {
          type = lib.types.submodule {
            options = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to enable AI tools, including the ollama inference server";
              };
              webui = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to enable the open-webui chat frontend (requires enable)";
              };
              acceleration = lib.mkOption {
                type = lib.types.enum [
                  "cpu"
                  "cuda"
                  "vulkan"
                  "rocm"
                ];
                default = "cpu";
                description = "The ollama build to use (cpu, cuda, vulkan, rocm)";
                example = "cuda";
              };
              model = lib.mkOption {
                type = lib.types.str;
                default = "qwen3.5:9b";
                description = "Ollama model to load for the inference server";
                example = "qwen3.5:4b";
              };
            };
          };
          default = { };
          description = "AI tools configuration";
          example = {
            enable = true;
            acceleration = "cuda";
          };
        };
        threeDTools = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to install 3D design/printing tools";
        };
        # Nous Research agent orchestrator
        hermes = lib.mkOption {
          type = lib.types.submodule {
            options = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to enable the hermes-agent gateway and dashboard services";
              };
              stateDir = lib.mkOption {
                type = lib.types.str;
                default = "/share/Docker/Hermes";
                description = "State directory for hermes; HERMES_HOME lives in its .hermes subdir";
                example = "/var/lib/hermes";
              };
              package = lib.mkOption {
                type = lib.types.enum [
                  "minimal"
                  "full"
                ];
                default = "minimal";
                description = "hermes-agent package variant (minimal core or full with optional integrations)";
                example = "full";
              };
              waitForNfs = lib.mkOption {
                type = lib.types.submodule {
                  options = {
                    enable = lib.mkOption {
                      type = lib.types.bool;
                      default = false;
                      description = "Hold the gateway/dashboard start until the NFS state share is mounted";
                    };
                    timeoutMinutes = lib.mkOption {
                      type = lib.types.int;
                      default = 10;
                      description = "How long to keep retrying the NFS mount before starting the units anyway";
                      example = 30;
                    };
                  };
                };
                default = { };
                description = "Wait-for-NFS bootstrap for the NFS-backed state directory";
              };
              dashboard = lib.mkOption {
                type = lib.types.submodule {
                  options = {
                    enable = lib.mkOption {
                      type = lib.types.bool;
                      default = true;
                      description = "Whether to run the hermes web dashboard service";
                    };
                    host = lib.mkOption {
                      type = lib.types.str;
                      default = "0.0.0.0";
                      description = "Bind address for the dashboard (tailnet-only exposure via tailscale serve)";
                      example = "127.0.0.1";
                    };
                    port = lib.mkOption {
                      type = lib.types.port;
                      default = 9119;
                      description = "TCP port for the dashboard";
                      example = 9119;
                    };
                  };
                };
                default = { };
                description = "Web dashboard configuration";
                example = {
                  enable = true;
                  host = "0.0.0.0";
                  port = 9119;
                };
              };
            };
          };
          default = { };
          description = "hermes-agent (Nous Research agent orchestrator) configuration";
          example = {
            enable = true;
            stateDir = "/share/Docker/Hermes";
            package = "minimal";
          };
        };
        virtualMachines = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to enable virtual machines";
        };

        tailscale = lib.mkOption {
          type = lib.types.submodule {
            options = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to enable Tailscale on this host";
              };
              routingFeatures = lib.mkOption {
                type = lib.types.enum [
                  "none"
                  "client"
                  "server"
                  "both"
                ];
                default = "client";
                description = ''
                  Tailscale routing features for this host.
                  - "none": no routing features
                  - "client": basic client (default)
                  - "server": can act as an exit node or advertise routes
                  - "both": client and server features
                '';
              };
              serve = lib.mkOption {
                type = lib.types.submodule {
                  options = {
                    enable = lib.mkOption {
                      type = lib.types.bool;
                      default = false;
                      description = "Whether to run a tailscale-serve oneshot unit for the configured backend";
                    };
                    httpsPort = lib.mkOption {
                      type = lib.types.port;
                      default = 443;
                      description = "Tailscale HTTPS port to serve on";
                      example = 443;
                    };
                    path = lib.mkOption {
                      type = lib.types.str;
                      default = "/";
                      description = "URL path to serve";
                      example = "/";
                    };
                    backend = lib.mkOption {
                      type = lib.types.str;
                      default = "http://127.0.0.1:9119";
                      description = "Backend URL to proxy to";
                      example = "http://127.0.0.1:8080";
                    };
                  };
                };
                default = { };
                description = "Tailscale serve configuration, applied by a oneshot unit";
                example = {
                  enable = true;
                  backend = "http://127.0.0.1:9119";
                };
              };
            };
          };
          default = { };
          description = "Tailscale configuration";
          example = {
            enable = true;
            routingFeatures = "server";
          };
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
                  "nfsvers=4.1"
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
                brightnessDevice = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "Brightness device for hypridle";
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

        # Desktop Applications
        desktopApps = lib.mkOption {
          type = lib.types.submodule {
            options = {
              brave = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to install Brave browser";
              };
              firefox = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to install Firefox browser";
              };
              social = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to install social/chat applications";
              };
              media = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to install media editing applications";
              };
              tools = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to install desktop utility applications";
              };
            };
          };
          default = { };
          description = "Desktop applications to install";
        };

      };
    };
  };

  config = {
    assertions = [
      {
        assertion =
          !config.hostSpec.nfsClient.enable
          || (config.hostSpec.nfsClient.server != "" && config.hostSpec.nfsClient.shares != [ ]);
        message = "NFS client is enabled but server is not set or shares list is empty";
      }
      {
        assertion =
          !config.hostSpec.users.secondary.enable || config.hostSpec.users.secondary.username != "";
        message = "Secondary user is enabled but username is not set";
      }
      {
        assertion = !config.hostSpec.aiTools.webui || config.hostSpec.aiTools.enable;
        message = "hostSpec.aiTools.webui is enabled but hostSpec.aiTools.enable is not";
      }
    ];
  };
}
