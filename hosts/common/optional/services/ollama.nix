_: {
  services = {
    ollama = {
      enable = true;
      host = "0.0.0.0";
      loadModels = [
        "llama3:latest"
      ];
      acceleration = "cuda";
    };

    open-webui = {
      enable = true;
      openFirewall = true;
    };

    /*
        nixai = {
          enabled = true;
          mcp = {
            enable = true;
            aiProvider = "ollama";
            aiModel = "llama3";
          };
        };
    */
  };
}
