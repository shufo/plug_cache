defmodule PlugCacheTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias PlugCache.Cache
  doctest PlugCache

  setup_all do
    Application.ensure_all_started(:plug_cache)
    :ok
  end

  setup do
    Cache.set("/hello", "ok")

    on_exit(fn ->
      TestHelper.delete_all_cache()
    end)

    :ok
  end

  @expected_state :sent
  @expected_response "ok"
  @expected_status 200
  test "Returns from cache if cache exists" do
    # Create a test connection
    conn = conn(:get, "/hello")

    # Invoke the plug
    conn = PlugCache.call(conn, [])

    # Assert the response and status
    assert conn.state == @expected_state
    assert conn.status == @expected_status
    assert conn.resp_body == @expected_response
  end

  @expected_state :unset
  test "Returns conn if there is no cache exists" do
    # Create a test connection
    conn = conn(:get, "/hello_without_cache")

    # Invoke the plug
    conn = PlugCache.call(conn, [])

    # Assert the response and status
    assert conn.state == @expected_state
  end

  @expected_response "hello!"
  @expected_status 200
  test "Cache the response if response is not cached yet" do
    # Create a test connection
    conn =
      conn(:get, "/hello_without_cache")
      |> resp(:ok, "hello!")

    # Invoke the plug
    conn = PlugCache.call(conn, [])
    :w

    conn |> send_resp

    # Assert the response and status
    assert conn.state == :set
    assert conn.status == @expected_status
    assert conn.resp_body == @expected_response

    # Assert the response is cached
    assert Cache.has_key?(conn.request_path <> conn.query_string)

    %Plug.Conn{request_path: path, query_string: query_string} = conn

    assert Cache.get(path <> query_string) == @expected_response

    # Assert the response is returned from cache on 2nd request
    conn = conn(:get, "/hello_without_cache")

    # Invoke the plug
    conn = PlugCache.call(conn, [])

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == @expected_status
    assert conn.resp_body == @expected_response
  end

  @expected_response "hello!"
  @expected_status 200
  @tag :ttl
  test "ttl works" do
    # Create a test connection
    conn =
      conn(:get, "/hello_without_cache")
      |> resp(:ok, "hello!")

    # Cache response for 1 seconds
    conn = PlugCache.call(conn, ttl: 1)

    conn |> send_resp

    # Assert the response and status
    assert conn.state == :set
    assert conn.status == @expected_status

    # Sleep 3 seconds
    :timer.sleep(1050)

    # Assert the cache is expired
    refute Cache.get(conn.request_path <> conn.query_string)

    # Create a test connection
    conn =
      conn(:get, "/hello_without_cache")
      |> resp(:ok, "hello!")

    # Cache response for 3 seconds
    conn = PlugCache.call(conn, ttl: 3)

    # send resp
    conn |> send_resp

    # Assert the response and status
    assert conn.state == :set
    assert conn.status == @expected_status
    assert conn.resp_body == @expected_response

    # Sleep 1 seconds
    :timer.sleep(1000)

    # Assert the cache is NOT expired
    assert Cache.has_key?(conn.request_path <> conn.query_string)

    # Sleep 2 seconds
    :timer.sleep(2000)

    # Assert the cache is expired
    assert Cache.has_key?(conn.request_path <> conn.query_string)
  end

  @expected_response "hello!"
  @expected_status 200
  test "query parameter works" do
    # Create a test connection
    conn =
      conn(:get, "/hello/test?page[page]=1&page[page_size]=10")
      |> resp(:ok, "hello!")

    # Cache response
    conn = PlugCache.call(conn, [])

    conn |> send_resp

    # Assert the response and status
    assert conn.state == :set
    assert conn.status == @expected_status
    assert conn.resp_body == @expected_response

    # Assert the cache is NOT expired
    assert Cache.has_key?(conn.request_path <> conn.query_string)

    conn = conn(:get, "/hello/test?page[page]=1&page[page_size]=10")

    # Cache response
    conn = PlugCache.call(conn, [])

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == @expected_status
    assert conn.resp_body == @expected_response
  end

  describe "table" do
    @expected_response "hello!"
    @expected_status 200
    test "multiple table" do
      # Create a test connection
      conn =
        conn(:get, "/hello/test?page[page]=1&page[page_size]=10")
        |> resp(:ok, "hello!")

      # Cache response
      conn = PlugCache.call(conn, table: :my_table)

      conn |> send_resp

      # Assert the response and status
      assert conn.state == :set
      assert conn.status == @expected_status
      assert conn.resp_body == @expected_response

      # Assert the cache is NOT expired
      assert Cache.has_key?(conn.request_path <> conn.query_string)

      conn = conn(:get, "/hello/test?page[page]=1&page[page_size]=10")

      # Cache response
      conn = PlugCache.call(conn, table: :my_table)

      # Assert the response and status
      assert conn.state == :sent
      assert conn.status == @expected_status
      assert conn.resp_body == @expected_response
    end
  end
end
