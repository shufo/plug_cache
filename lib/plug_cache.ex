defmodule PlugCache do
  import Plug.Conn, only: [register_before_send: 2, send_resp: 3, halt: 1]
  alias PlugCache.Cache

  def init(opts \\ []), do: opts

  def call(conn, opts) do
    if Cache.has_key?(key(conn)) do
      send_resp_with_cache(conn, opts)
    else
      conn
      |> register_before_send(&set_cache(&1, opts))
    end
  end

  defp key(%Plug.Conn{params: %Plug.Conn.Unfetched{}} = conn) do
    %{request_path: request_path, query_string: query_string} = conn
    "#{request_path}#{query_string}"
  end

  defp key(%Plug.Conn{request_path: request_path, params: params} = _conn) do
    "#{request_path}#{Plug.Conn.Query.encode(params)}"
  end

  defp send_resp_with_cache(conn, opts) do
    case Cache.get(key(conn), opts) do
      nil ->
        conn

      body ->
        conn
        |> send_resp(:ok, body)
        |> halt
    end
  end

  defp set_cache(%Plug.Conn{resp_body: body} = conn, opts) do
    Cache.set(key(conn), body, opts)

    conn
  end

  def invalidate(prefix) do
    with keys <- Cache.keys(),
         filtered_keys <- Enum.filter(keys, &filter_by_path(&1, prefix)) do
      Task.async_stream(filtered_keys, __MODULE__, :invalidate_key, [])
      |> Enum.to_list()
    end
  end

  defp filter_by_path(key, path), do: String.starts_with?(key, path)

  def invalidate_key(key) do
    Cache.delete(key)
  end
end
