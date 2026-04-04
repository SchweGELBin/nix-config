{
  config,
  inputs,
  lib,
  ...
}:
let
  nginx = config.sys.nginx;
  cfg = nginx.ollama;
  secrets = config.sops.secrets;

  models = [
    "gpt-oss:120b-cloud"
    "granite4:350m"
    "smollm2:135m"
  ];
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      ollama = {
        enable = true;
        loadModels = models;
        port = cfg.port;
        user = "ollama";
      };
    }
    // lib.optionalAttrs cfg.web.enable {
      librechat = {
        enable = cfg.web.mode == "librechat";
        credentialsFile = secrets.librechat_env.path;
        enableLocalDB = true;
        env = {
          ALLOW_REGISTRATION = true;
          PORT = cfg.web.port;
        };
        settings = {
          cache = true;
          endpoints.custom = [
            {
              name = "Ollama";
              apiKey = "ollama";
              baseURL = "http://localhost:${toString cfg.port}/v1/";
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
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.web.port}";
      };
      open-webui = {
        enable = cfg.web.mode == "open-webui";
        port = cfg.web.port;
      };
      nextjs-ollama-llm-ui = {
        enable = cfg.web.mode == "nextjs-ollama-llm-ui";
        port = cfg.web.port;
      };
    };
    sops.secrets = {
      librechat_env.owner = "librechat";
      ollama_env.owner = "ollama";
    };
  };

  options = {
    sys.nginx.ollama = {
      enable = lib.mkEnableOption "Enable Ollama";
      fqdn = lib.mkOption {
        default = "ai.${nginx.domain}";
        description = "Ollama Web Domain";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 11434;
        description = "Ollama Port";
        type = lib.types.port;
      };
      web = {
        enable = lib.mkEnableOption "Enable Ollama Web" // {
          default = true;
        };
        mode = lib.mkOption {
          default = "librechat";
          description = "Ollama Web Service";
          type = lib.types.enum [
            "librechat"
            "nextjs-ollama-llm-ui"
            "open-webui"
          ];
        };
        port = lib.mkOption {
          default = 11435;
          description = "Ollama Web Port";
          type = lib.types.port;
        };
      };
    };
  };
}
