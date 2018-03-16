# PlugCache

A response caching plug based on [nebulex](https://github.com/cabol/nebulex)
## Installation

Add plug_cache to your mix dependencies

```elixir
def deps do
  [
    {:plug_cache, "~> 0.1.0-rc1"}
  ]
end
```

Add to your applications

```elixir
@applications = [
  ...
  :plug_cache
]
```

## Usage

- Basic usage

```elixir
plug PlugCache
```

simply add the `PlugCache` will caches the responses in memory.


- Usage in Phoenix

```elixir
defmodule MyApp.PageController do

  plug PlugCache, ttl: 86400 when action in [:index]

  def index(conn, _params) do
    conn
    |> render(:index)
  end
end
```

This will caches the `index` action response on first time, then return cached response on next time for a day.

Cache key is based on request path and params.
Request path like below produces different cache.

```
/v1/hello
/v1/hello?a=b
```

If you want to manipulate the cache manually, you can use `PlugCache.Cache` like this.

```elixir
PlugCache.Cache.set(key, value)
PlugCache.Cache.delete(key)
PlugCache.Cache.update(key, initial, fn(x) -> x + 1 end)
```

## Configurations

### Per plug configurations

example:

```elixir
plug PlugCache, ttl: 100 # cache 100 seconds
```

|key|description|default|example|
|--:|--:|--:|--:|
|`ttl`| TTL for cache (second) | `nil` (never expired) | `100` |

## Distributed Cache

If you want to distribute the cache in erlang cluster, then use `PlugCache.DistCache`

```elixir
config :plug_cache,
  adapter: PlugCache.DistCache
```

By using this adapter, caches are shared in cluster.

So manual cache operation is propagated to across cluster.

Distribution requires clustering erlang processes. Tools like [libcluster](https://github.com/bitwalker/libcluster), [peerage](https://github.com/mrluc/peerage) helps clustering erlang nodes.

## Benchmark

### Local Cache

```
Operating System: Linux
CPU Information: Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz
Number of Available Cores: 8
Available memory: 31.37 GB
Elixir 1.6.0-dev
Erlang 20.1
Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
parallel: 1
inputs: none specified
Estimated total run time: 7 s

Benchmarking test...
```


|Name|           ips |       average  |deviation |        median  |       99th %|
|--:|--:|--:|--:|--:|--:|
|test|       63.79 K   |    15.68 μs |  ±149.14%  |        14 μs|          31 μs|

### Distributed Cache

```
Operating System: Linux
CPU Information: Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz
Number of Available Cores: 8
Available memory: 31.37 GB
Elixir 1.6.0-dev
Erlang 20.1
Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
parallel: 1
inputs: none specified
Estimated total run time: 7 s


Benchmarking test...
```


|Name   |        ips  |      average | deviation   |      median     |    99th %|
|--:|--:|--:|--:|--:|--:|
|test      | 45.60 K  |     21.93 μs |  ±177.22%   |       20 μs      |     42 μs|

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

MIT
