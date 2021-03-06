Code.require_file "../test_helper", __FILE__

defmodule FileTest do
  use ExUnit.Case

  test :expand_path_with_binary do
    assert File.expand_path("/foo/bar") == "/foo/bar"
    assert File.expand_path("/foo/bar/") == "/foo/bar"
    assert File.expand_path("/foo/bar/.") == "/foo/bar"
    assert File.expand_path("/foo/bar/../bar") == "/foo/bar"

    assert File.expand_path("bar", "/foo") == "/foo/bar"
    assert File.expand_path("bar/", "/foo") == "/foo/bar"
    assert File.expand_path("bar/.", "/foo") == "/foo/bar"
    assert File.expand_path("bar/../bar", "/foo") == "/foo/bar"
    assert File.expand_path("../bar/../bar", "/foo/../foo/../foo") == "/bar"

    full = File.expand_path("foo/bar")
    assert File.expand_path("bar/../bar", "foo") == full
  end

  test :expand_path_with_list do
    assert File.expand_path('/foo/bar') == '/foo/bar'
    assert File.expand_path('/foo/bar/') == '/foo/bar'
    assert File.expand_path('/foo/bar/.') == '/foo/bar'
    assert File.expand_path('/foo/bar/../bar') == '/foo/bar'
  end

  test :regular do
    assert File.regular?(__FILE__)
    assert File.regular?(binary_to_list(__FILE__))
    refute File.regular?("#{__FILE__}.unknown")
  end

  test :basename_with_binary do
    assert File.basename("foo") == "foo"
    assert File.basename("/foo/bar") == "bar"
    assert File.basename("/") == ""

    assert File.basename("~/foo/bar.ex", ".ex") == "bar"
    assert File.basename("~/foo/bar.exs", ".ex") == "bar.exs"
    assert File.basename("~/for/bar.old.ex", ".ex") == "bar.old"
  end

  test :basename_with_list do
    assert File.basename('foo') == 'foo'
    assert File.basename('/foo/bar') == 'bar'
    assert File.basename('/') == ''

    assert File.basename('~/foo/bar.ex', '.ex') == 'bar'
    assert File.basename('~/foo/bar.exs', '.ex') == 'bar.exs'
    assert File.basename('~/for/bar.old.ex', '.ex') == 'bar.old'
  end

  test :join_with_binary do
    assert File.join([""]) == ""
    assert File.join(["foo"]) == "foo"
    assert File.join(["/", "foo", "bar"]) == "/foo/bar"
    assert File.join(["~", "foo", "bar"]) == "~/foo/bar"
  end

  test :join_with_list do
    assert File.join(['']) == ''
    assert File.join(['foo']) == 'foo'
    assert File.join(['/', 'foo', 'bar']) == '/foo/bar'
    assert File.join(['~', 'foo', 'bar']) == '~/foo/bar'
  end

  test :split_with_binary do
    assert File.split("") == ["/"]
    assert File.split("foo") == ["foo"]
    assert File.split("/foo/bar") == ["/", "foo", "bar"]
  end

  test :split_with_list do
    assert File.split('') == ''
    assert File.split('foo') == ['foo']
    assert File.split('/foo/bar') == ['/', 'foo', 'bar']
  end

  test :read_with_binary do
    assert_match { :ok, "FOO\n" }, File.read(File.expand_path("../fixtures/foo.txt", __FILE__))
    assert_match { :error, :enoent }, File.read(File.expand_path("../fixtures/missing.txt", __FILE__))
  end

  test :read_with_list do
    assert_match { :ok, "FOO\n" }, File.read(File.expand_path('../fixtures/foo.txt', __FILE__))
    assert_match { :error, :enoent }, File.read(File.expand_path('../fixtures/missing.txt', __FILE__))
  end

  test :read! do
    assert File.read!(File.expand_path("../fixtures/foo.txt", __FILE__)) == "FOO\n"
    expected_message = "could not read file fixtures/missing.txt: no such file or directory"

    assert_raise File.Exception, expected_message, fn ->
      File.read!("fixtures/missing.txt")
    end
  end

  test :read_info do
    {:ok, info} = File.read_info(__FILE__)
    assert info.mtime
  end

  test :read_info! do
    assert File.read_info!(__FILE__).mtime
  end

  test :read_info_with_invalid_file do
    assert_match { :error, _ }, File.read_info("./invalid_file")
  end

  test :read_info_with_invalid_file! do
    assert_raise File.Exception, fn ->
      File.read_info!("./invalid_file")
    end
  end
end
