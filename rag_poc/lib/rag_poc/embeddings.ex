defmodule RagPoc.Embeddings do
  @ollama System.get_env("OLLAMA_HOST", "http://localhost:11434")

  def embed(text) when is_binary(text) do
    %{body: %{"embedding" => vector}} =
      Req.post!("#{@ollama}/api/embeddings",
        json: %{model: "nomic-embed-text", prompt: text}
      )

    vector
  end

  def embed_batch(texts) do
    # Simple sequential for PoC; Task.async_stream for speed
    Enum.map(texts, &embed/1)
  end
end
