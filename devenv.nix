{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.system; };
in
{
  packages = [
    pkgs.livebook
    inputs.expert.packages.${pkgs.system}.default
  ];

  languages.elixir.enable = true;
  languages.elixir.package = pkgs-unstable.beam29Packages.elixir_1_20;

  scripts.infra-up.exec = ''
    docker compose up -d
  '';
  scripts.infra-down.exec = ''
    docker compose down
  '';
  scripts.pull-models.exec = ''
    docker compose exec ollama ollama pull llama3.2
    docker compose exec ollama ollama pull nomic-embed-text
  '';

  env = {
    OLLAMA_HOST = "http://localhost:11434";
    QDRANT_URL = "http://localhost:6333";
    COLLECTION_NAME = "ufo_sightings";
  };

  enterShell = ''
    export PATH="$HOME/.mix/escripts:$PATH"
    echo ""
    echo "-- elixir_rag_poc --"
    echo "1. infra-up         Start Qdrant + Ollama containers"
    echo "2. pull-models      Download LLM + embedding model (one-time)"
    echo "3. livebook server"
    echo "4. Open notebooks in order: 01 → 02 → 03"
    echo ""
    echo "Qdrant dashboard: http://localhost:6333/dashboard"
    echo ""
  '';

  git-hooks.hooks.mix-format.enable = true;
}
