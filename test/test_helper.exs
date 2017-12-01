ExUnit.start()

defmodule TestHelper do
  alias PlugCache.Cache

  def delete_all_cache() do
    Cache.flush()
  end
end
