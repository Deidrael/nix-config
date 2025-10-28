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
          description = "The home directory of the user";
          default =
            let
              user = config.hostSpec.primaryUsername;
            in
            "/home/${user}";
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
        networking = lib.mkOption {
          default = { };
          type = lib.types.attrsOf lib.types.anything;
          description = "An attribute set of networking information";
        };
        wifi = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate if a host has wifi";
        };
        domain = lib.mkOption {
          type = lib.types.str;
          default = "localdomain";
          description = "The domain of the host";
        };
        persistFolder = lib.mkOption {
          type = lib.types.str;
          description = "The folder to persist data if impermenance is enabled";
          default = "";
        };
        work = lib.mkOption {
          default = { };
          type = lib.types.attrsOf lib.types.anything;
          description = "An attribute set of work-related information if isWork is true";
        };

        # Configuration Settings
        users = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "An attribute set of all users on the host";
          default = [ config.hostSpec.primaryUsername ];
        };
        isMinimal = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate a minimal host";
        };
        isProduction = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Indicate a production host";
        };
        isServer = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate a server host";
        };
        isWork = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate a host that uses work resources";
        };
        isDevelopment = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate a host used for development";
        };
        isMobile = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate a mobile host";
        };
        useYubikey = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate if the host uses a yubikey";
        };
        voiceCoding = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate a host that uses voice coding";
        };
        isAutoStyled = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate a host that wants auto styling like stylix";
        };
        theme = lib.mkOption {
          type = lib.types.str;
          default = "dracula";
          description = "The theme to use for the host (stylix, vscode, neovim, etc)";
        };
        useNeovimTerminal = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate a host that uses neovim for terminals";
        };
        useWindowManager = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Indicate a host that uses a window manager";
        };
        hdr = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate a host that uses HDR";
        };
        scaling = lib.mkOption {
          type = lib.types.str;
          default = "1";
          description = "Indicate what scaling to use. Floating point number";
        };
        wallpaper = lib.mkOption {
          type = lib.types.path;
          default = "~/zen-01.png";
          description = "Path to wallpaper to use for system";
        };
        useWayland = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate a host that uses Wayland";
        };
        defaultBrowser = lib.mkOption {
          type = lib.types.str;
          default = "firefox";
          description = "The default browser to use on the host";
        };
        defaultEditor = lib.mkOption {
          type = lib.types.str;
          default = "nvim";
          description = "The default editor command to use on the host";
        };
        defaultDesktop = lib.mkOption {
          type = lib.types.str;
          default = "Hyprland";
          description = "The default desktop environment to use on the host";
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
          assertion =
            !config.hostSpec.isWork || (config.hostSpec.isWork && !builtins.isNull config.hostSpec.work);
          message = "isWork is true but no work attribute set is provided";
        }
        {
          assertion = !isImpermanent || (isImpermanent && !("${config.hostSpec.persistFolder}" == ""));
          message = "config.system.impermanence.enable is true but no persistFolder path is provided";
        }
        {
          assertion = !(config.hostSpec.voiceCoding && config.hostSpec.useWayland);
          message = "Talon, which is used for voice coding, does not support Wayland. See https://github.com/splondike/wayland-accessibility-notes";
        }
      ];
  };
}
