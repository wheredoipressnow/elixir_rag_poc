defmodule RagPoc.Qdrant do
  @base_url System.get_env("QDRANT_URL", "http://localhost:6333")

  def create_collection(name, vector_size) do
    Req.put!("#{@base_url}/collections/#{name}",
      json: %{
        vectors: %{size: vector_size, distance: "Cosine"}
      }
    )
  end

  def upsert_points(collection, points) do
    Req.put!("#{@base_url}/collections/#{collection}/points",
      json: %{points: points}
    )
  end

  def search(collection, vector, opts \\ []) do
    limit = Keyword.get(opts, :limit, 5)
    filter = Keyword.get(opts, :filter, nil)

    body = %{vector: vector, limit: limit, with_payload: true}
    body = if filter, do: Map.put(body, :filter, filter), else: body

    Req.post!("#{@base_url}/collections/#{collection}/points/search",
      json: body
    ).body
  end
end
