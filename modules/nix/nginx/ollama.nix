{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.ollama.enable;
  secrets = config.sops.secrets;

  models = [
    "gpt-oss:120b-cloud"
    "granite4:350m"
    "smollm2:135m"
  ];
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf enable {
    services = {
      ollama = {
        enable = true;
        loadModels = models;
        port = cfg.ollama.port;
        user = "ollama";
      };
    }
    // lib.optionalAttrs cfg.ollama.web.enable {
      librechat = {
        enable = cfg.ollama.web.mode == "librechat";
        credentialsFile = secrets.librechat_env.path;
        enableLocalDB = true;
        env = {
          ALLOW_REGISTRATION = true;
          PORT = cfg.ollama.web.port;
        };
        settings = {
          cache = true;
          endpoints.custom = [
            {
              name = "Ollama";
              apiKey = "ollama";
              baseURL = "http://localhost:${toString cfg.ollama.port}/v1/";
              forcePrompt = false;
              modelDisplayLabel = "Ollama";
              models.default = models;
              summarize = false;
              summaryModel = "current_model";
              titleConvo = true;
              titleModel = "current_model";
            }
          ];
          version = "1.2.8";
        };
      };
      nginx.virtualHosts.${cfg.ollama.web.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.ollama.web.port}";
      };
      open-webui = {
        enable = cfg.ollama.web.mode == "open-webui";
        port = cfg.ollama.web.port;
      };
      nextjs-ollama-llm-ui = {
        enable = cfg.ollama.web.mode == "nextjs-ollama-llm-ui";
        port = cfg.ollama.web.port;
      };
    };
    sops.secrets = {
      librechat_env.owner = "librechat";
      ollama_env.owner = "ollama";
    };
  };
}
