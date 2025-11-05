{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.hostSpec.ollama {
    services = {
      ollama = {
        enable = true;
        host = "0.0.0.0";
        loadModels = [
          "llama3.2:latest"
        ];
        acceleration = "cuda";
      };

      open-webui = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
