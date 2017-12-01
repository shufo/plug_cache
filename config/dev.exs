use Mix.Config

config :plug_cache, adapter: PlugCache.LocalCache

config :plug_cache, PlugCache.LocalCache,
  adapter: Nebulex.Adapters.Local,
  gc_interval: 86_400

# L2
config :plug_cache, PlugCache.DistCache,
  adapter: Nebulex.Adapters.Dist,
  local: PlugCache.DistCache.Local,
  node_picker: Nebulex.Adapters.Dist

config :plug_cache, PlugCache.DistCache.Local,
  adapter: Nebulex.Adapters.Local,
  gc_interval: 86_400

config :plug_cache, PlugCache.MultilevelCache,
  adapter: Nebulex.Adapters.Multilevel,
  cache_model: :inclusive,
  levels: [PlugCache.LocalCache, PlugCache.DistCache]
