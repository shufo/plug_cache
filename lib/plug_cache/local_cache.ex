defmodule PlugCache.LocalCache do
  use Nebulex.Cache,
    otp_app: :plug_cache,
    adapter: Nebulex.Adapters.Local

  @config [gc_interval: 86_400]
end
