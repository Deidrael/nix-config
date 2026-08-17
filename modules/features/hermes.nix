{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.hostSpec.hermes;
  system = pkgs.stdenv.hostPlatform.system;
  # "minimal" keeps the closure small on ARM (no ctranslate2/onnxruntime extras);
  # "full" enables all optional integrations from the upstream flake
  hermesPackage =
    if cfg.package == "full" then
      inputs.hermes-agent.packages.${system}.default
    else
      inputs.hermes-agent.packages.${system}.minimal;
in
{
  # Import unconditionally: imports must be static (modules.nix only
  # discharges mkIf for items inside the list). The upstream module gates
  # all of its config on services.hermes-agent.enable, so this is inert
  # when the feature is disabled.
  imports = [
    inputs.hermes-agent.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {
    services.hermes-agent = {
      enable = true;
      package = hermesPackage;
      inherit (cfg) stateDir;
      settings.model = "qwen3.5:9b";
      restart = "always";
    };

    # Gateway unit comes from the upstream module; add NFS-autofs ordering
    # and the memory cap matching the former container's mem_limit
    systemd.services = {
      hermes-agent = {
        unitConfig.WantsMountsFor = [ "/share/Docker" ];
        after = [
          "tailscaled.service"
        ]
        ++ lib.optionals cfg.waitForNfs.enable [ "hermes-wait-for-nfs.service" ];
        wants = [
          "tailscaled.service"
        ]
        ++ lib.optionals cfg.waitForNfs.enable [ "hermes-wait-for-nfs.service" ];
        serviceConfig = {
          MemoryMax = "2G";
          # "-" prefix demotes the implicit RequiresMountsFor= on the working
          # directory (systemd.exec(5)) to WantsMountsFor=, so an unmounted
          # NFS stateDir can never hard-fail the unit; the process then starts
          # in / and the automount serves the stateDir once the NAS is up.
          # mkForce: the upstream module sets a plain value we deliberately
          # override (nixpkgs 26.11 rejects two plain definitions).
          WorkingDirectory = lib.mkForce "-${cfg.stateDir}/workspace";
          # The gateway restarts until the NFS stateDir is reachable (NAS may
          # boot slower than this host); disable the start-rate limit so a
          # long NAS outage cannot pin the unit into a dead state
          StartLimitIntervalSec = 0;
        };
      };

      # Retry-loop oneshot (tailscale-serve pattern): hold the agent units'
      # start until the NFS state share is actually mounted. All dependencies
      # on it are soft — after the timeout the units start anyway instead of
      # failing, and the automount retries lazily on access.
      hermes-wait-for-nfs = lib.mkIf cfg.waitForNfs.enable {
        description = "Wait for Hermes NFS state directory";
        wantedBy = [ "multi-user.target" ];
        before = [
          "hermes-agent.service"
          "hermes-agent-dashboard.service"
        ];
        after = [
          "tailscaled.service"
          "network-online.target"
        ];
        wants = [
          "tailscaled.service"
          "network-online.target"
        ];

        script = ''
          # Wait for tailscale0 interface to appear before attempting NFS
          _tries=0
          while [ ! -d /sys/class/net/tailscale0 ] && [ "$_tries" -lt 30 ]; do
            _tries=$((_tries + 1))
            sleep 1
          done

          _deadline=$(( $(date +%s) + ${toString cfg.waitForNfs.timeoutMinutes} * 60 ))
          while [ "$(date +%s)" -lt "$_deadline" ]; do
            if systemctl start share-Docker.mount >/dev/null 2>&1 \
              && systemctl is-active --quiet share-Docker.mount; then
              exit 0
            fi
            sleep 5
          done
          exit 1
        '';

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = 10;
          ExecStop = "${pkgs.bash}/bin/bash -c 'umount /share/Docker || ${pkgs.util-linux}/bin/umount -l /share/Docker'";
        };

        path = [
          pkgs.bash
          pkgs.coreutils
          pkgs.util-linux
        ];
      };

      hermes-agent-dashboard = lib.mkIf cfg.dashboard.enable {
        description = "Hermes Agent Dashboard";
        wantedBy = [ "multi-user.target" ];
        after = [
          "network-online.target"
          "tailscaled.service"
        ]
        ++ lib.optionals cfg.waitForNfs.enable [ "hermes-wait-for-nfs.service" ];
        wants = [
          "network-online.target"
          "tailscaled.service"
        ]
        ++ lib.optionals cfg.waitForNfs.enable [ "hermes-wait-for-nfs.service" ];

        environment = {
          HOME = cfg.stateDir;
          HERMES_HOME = "${cfg.stateDir}/.hermes";
          HERMES_MANAGED = "true";
        };

        serviceConfig = {
          User = config.services.hermes-agent.user;
          Group = config.services.hermes-agent.group;
          WorkingDirectory = "-${cfg.stateDir}/workspace";
          ExecStart = "${hermesPackage}/bin/hermes dashboard --host ${cfg.dashboard.host} --port ${toString cfg.dashboard.port} --no-open";
          Restart = "always";
          RestartSec = 5;
          UMask = "0007";
          MemoryMax = "2G";
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ProtectHome = false;
          ReadWritePaths = [
            cfg.stateDir
            "${cfg.stateDir}/workspace"
          ];
          PrivateTmp = true;
          StartLimitIntervalSec = 0;
        };

        path = [
          hermesPackage
          pkgs.bash
          pkgs.coreutils
          pkgs.git
        ];

        unitConfig.WantsMountsFor = [ "/share/Docker" ];
      };
    };
  };
}
