{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  packages = [
    pkgs.livebook
  ];

  languages.elixir.enable = true;
  languages.elixir.package = pkgs.beam27Packages.elixir_1_19;

  scripts.infra-up.exec = ''
    docker compose up -d
  '';
  scripts.infra-down.exec = ''
    docker compose down
  '';
  scripts.pull-models.exec = ''
    ollama pull llama3.2
    ollama pull nomic-embed-text
  '';

  env = {
    OLLAMA_HOST = "http://localhost:11434";
    QDRANT_URL = "http://localhost:6333";
    COLLECTION_NAME = "ufo_sightings";
  };

  git-hooks.hooks.mix-format.enable = true;
}
