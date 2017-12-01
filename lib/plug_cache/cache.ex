defmodule PlugCache.Cache do
  @adapter Application.get_env(:plug_cache, :adapter, PlugCache.LocalCache)

  defdelegate get(key, opts \\ []), to: @adapter

  defdelegate get!(key, opts \\ []), to: @adapter

  defdelegate set(key, value, opts \\ []), to: @adapter

  defdelegate delete(key, opts \\ []), to: @adapter

  defdelegate has_key?(key), to: @adapter

  defdelegate size(), to: @adapter

  defdelegate flush(), to: @adapter

  defdelegate keys(), to: @adapter

  defdelegate reduce(acc, reducer, opts \\ []), to: @adapter

  defdelegate to_map(opts \\ []), to: @adapter

  defdelegate pop(key, opts \\ []), to: @adapter

  defdelegate get_and_update(key, fun, opts \\ []), to: @adapter

  defdelegate update(key, initial, fun, opts \\ []), to: @adapter

  defdelegate transaction(key, fun), to: @adapter
end
