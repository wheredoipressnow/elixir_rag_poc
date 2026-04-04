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
