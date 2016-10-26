gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require "minitest/nyan_cat"
require './lib/path_handler'

class PathHandlerTest < Minitest::Test

  def setup
    @get_lines = [
      "GET / HTTP/1.1",
      "Host: localhost:9292",
      "Connection: keep-alive",
      "Cache-Control: no-cache",
      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
      "Postman-Token: e2095661-c6ca-4ca6-11c6-5feebd9d2bfb",
      "Accept: */*",
      "Accept-Encoding: gzip, deflate, sdch, br",
      "Accept-Language: en-US,en;q=0.8"
      ]
    
    @post_lines = [
      "POST /cgi-bin/process.cgi HTTP/1.1", 
      "User-Agent: Mozilla/4.0 (compatible; MSIE5.01; Windows NT)", 
      "Host: www.tutorialspoint.com", 
      "Content-Type: application/x-www-form-urlencoded", 
      "Content-Length: length", "Accept-Language: en-us", 
      "Accept-Encoding: gzip, deflate", 
      "Connection: Keep-Alive"]
  end

  def test_it_exists
    assert PathHandler.new
  end

  def test_it_returns_nothing_for_home_page
    path = PathHandler.new("/").handle
    expected = nil
    assert_equal expected, path
  end

  def test_it_returns_hello_world_for_hello_path
    path = PathHandler.new("/hello").handle
    expected = "Hello, World! "
    assert_equal expected, path
  end

  def test_it_returns_datetime_for_datetime_path
    path = PathHandler.new("/datetime").handle
    expected = Time.now.strftime('%l:%m%p on %A, %B %e, %Y')
    assert_equal expected, path
  end

  def test_it_returns_total_requests_without_number_for_shutdown_path
    path = PathHandler.new("/shutdown").handle
    expected = "Total Requests: "
    assert_equal expected, path
  end

end