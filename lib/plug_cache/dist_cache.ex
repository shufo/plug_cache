defmodule PlugCache.DistCache do
  use Nebulex.Cache,
    otp_app: :plug_cache,
    adapter: Nebulex.Adapters.Dist

  @config [local: PlugCache.DistCache.Local, node_picker: Nebulex.Adapters.Dist]

  defmodule Local do
    use Nebulex.Cache,
      otp_app: :plug_cache,
      adapter: Nebulex.Adapters.Local

    @config [gc_interval: 86_400]
  end
end
