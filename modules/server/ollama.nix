{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.hostSpec.ollama {
    services = {
      ollama = {
        enable = true;
        package = pkgs.ollama-cuda;
        host = "0.0.0.0";
        loadModels = [
          "llama3.2:latest"
        ];
      };

      open-webui = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
