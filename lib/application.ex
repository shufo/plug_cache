defmodule PlugCache.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(PlugCache.LocalCache, []),
      supervisor(PlugCache.DistCache, []),
      supervisor(PlugCache.DistCache.Local, [])
    ]

    Application.put_env(
      :plug_cache,
      PlugCache.LocalCache,
      adapter: Nebulex.Adapters.Local,
      gc_interval: 86_400
    )

    Application.put_env(
      :plug_cache,
      PlugCache.DistCache,
      adapter: Nebulex.Adapters.Dist,
      local: PlugCache.DistCache.Local,
      node_picker: Nebulex.Adapters.Dist
    )

    Application.put_env(
      :plug_cache,
      PlugCache.DistCache.Local,
      adapter: Nebulex.Adapters.Local,
      gc_interval: 86_400
    )

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
