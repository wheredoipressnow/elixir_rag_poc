defmodule RagPoc.Chain do
  alias RagPoc.Embeddings
  alias RagPoc.Qdrant

  @collection "ufo_sightings"

  def ask(question, opts \\ []) do
    k = Keyword.get(opts, :k, 5)
    model = Keyword.get(opts, :model, "llama3.2")

    # 1. Embed the question
    q_vector = Embeddings.embed(question)

    # 2. Retrieve similar documents
    %{"result" => results} = Qdrant.search(@collection, q_vector, limit: k)

    # 3. Build context from payloads
    context =
      results
      |> Enum.map(& &1["payload"]["text"])
      |> Enum.join("\n---\n")

    scores = Enum.map(results, & &1["score"])

    # 4. Ask the LLM
    prompt = """
    You are a helpful assistant answering questions about UFO sighting reports.
    Use ONLY the following reports to answer. Cite specific sightings by date
    and location when possible. If the reports don't contain relevant info,
    say so.

    REPORTS:
    #{context}

    QUESTION: #{question}
    """

    %{body: %{"message" => %{"content" => answer}}} =
      Req.post!(
        "#{System.get_env("OLLAMA_HOST", "http://localhost:11434")}/api/chat",
        json: %{
          model: model,
          stream: false,
          messages: [%{role: "user", content: prompt}]
        }
      )

    %{
      answer: answer,
      sources: length(results),
      scores: scores,
      top_score: List.first(scores)
    }
  end
end
