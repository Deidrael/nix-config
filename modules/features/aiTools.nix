{
  config,
  lib,
  pkgs,
  ...
}:
let
  aiTools = config.hostSpec.aiTools;
  ollamaPackage = {
    cpu = pkgs.ollama;
    cuda = pkgs.ollama-cuda;
    vulkan = pkgs.ollama-vulkan;
    rocm = pkgs.ollama-rocm;
  };
in
{
  config = lib.mkIf aiTools.enable (
    lib.mkMerge [
      {
        services.ollama = {
          enable = true;
          package = ollamaPackage.${aiTools.acceleration};
          host = "0.0.0.0";
          port = 11434;
          loadModels = [
            aiTools.model
          ];
          modelsDir = "/var/lib/ollama/models";
          environmentVariables = {
            OLLAMA_CONTEXT_LENGTH = "65536";
            OLLAMA_KEEP_ALIVE = "10m";
            OLLAMA_NUM_PARALLEL = "1";
            OLLAMA_MAX_LOADED_MODELS = "1";
            OLLAMA_KV_CACHE_TYPE = "q8_0";
            OLLAMA_FLASH_ATTENTION = "1";
          };
          # tailscale0 is a trusted interface; openFirewall = false keeps
          # 11434 closed on physical interfaces.
          openFirewall = false;
        };
        networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 11434 ];
      }
      (lib.mkIf (aiTools.acceleration == "cpu") {
        systemd.services.ollama.serviceConfig.CPUQuota = "500%";
      })
      (lib.mkIf aiTools.webui {
        services.open-webui = {
          enable = true;
          host = "0.0.0.0";
        };
      })
    ]
  );
}
