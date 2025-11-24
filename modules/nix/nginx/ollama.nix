{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.ollama.enable;
  #secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf enable {
    services = {
      ollama = {
        enable = true;
        loadModels = [
          "gpt-oss:120b-cloud"
          "granite4:350m"
          "smollm2:135m"
        ];
        port = cfg.ollama.port;
        user = "ollama";
      };
    }
    // lib.optionalAttrs cfg.ollama.web.enable {
      librechat = {
        enable = cfg.ollama.web.mode == "librechat";
        env.PORT = cfg.ollama.web.port;
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
    #sops.secrets.ollama_env.owner = "ollama";
  };
}
