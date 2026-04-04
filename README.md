# elixir_rag_poc

A local RAG proof of concept for querying public datasets using natural language.
Built with Elixir, Livebook, Qdrant, and Ollama.

## Goal

Learn how vector databases, embeddings, and LLM-driven retrieval work by building
a working pipeline from scratch. The dataset is NUFORC UFO sighting reports
(public domain). Everything runs locally - no API keys needed.

Notebook 01 ingests only 2000 records by default to keep embedding time
reasonable on local hardware. Adjust the `Enum.take(2000)` limit to ingest more.

---

## Stack

| Layer            | Tool                    | Why                                                       |
|------------------|-------------------------|-----------------------------------------------------------|
| LLM runtime      | Ollama (Docker)         | Self-hosted, OpenAI-compatible API, easy model switching  |
| Embedding model   | nomic-embed-text        | Runs via Ollama, 768-dim vectors, no separate service     |
| Chat model        | llama3.2                | Good quality/speed tradeoff for local use                 |
| Vector DB         | Qdrant (Docker)         | Dashboard UI for inspecting vectors, solid REST API       |
| App language      | Elixir                  | LangChain Elixir (hex: langchain ~> 0.7)                  |
| Exploration UI    | Livebook                | Interactive cells, Kino widgets, .livemd version control  |
| Dev environment   | devenv.sh               | Reproducible Elixir/Erlang toolchain via Nix              |
| Infrastructure    | Docker Compose          | Qdrant + Ollama as containers (GPU-ready)                 |

### Why hybrid devenv + Docker

- devenv.sh manages the Elixir/Erlang toolchain and Livebook (native access
  to Mix project, no container networking friction)
- Docker Compose manages Qdrant and Ollama (both are container-native, better
  community support, GPU passthrough is straightforward)
- Qdrant's Elixir hex client is stale (last release May 2023) - we call
  Qdrant's REST API directly with Req instead

---

## How to run

Prerequisites: [devenv.sh](https://devenv.sh) and Docker.

```bash
# 1. Enter the dev shell (installs Elixir, Livebook, sets env vars)
devenv shell

# 2. Start Qdrant + Ollama containers
infra-up

# 3. Download the embedding + chat models (only needed once, ~2 GB)
pull-models

# 4. Download the NUFORC UFO sightings dataset from Kaggle
mkdir -p rag_poc/data
curl -L -o rag_poc/data/ufo-sightings.zip https://www.kaggle.com/api/v1/datasets/download/NUFORC/ufo-sightings
unzip rag_poc/data/ufo-sightings.zip -d rag_poc/data

# 5. Install Elixir dependencies
cd rag_poc && mix deps.get && cd ..

# 6. Start Livebook and open notebooks in order: 01 → 02 → 03
livebook server
```

To stop everything:

```bash
infra-down
```
