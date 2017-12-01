# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :plug_cache, adapter: PlugCache.LocalCache

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :plug_cache, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:plug_cache, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

# L1
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
