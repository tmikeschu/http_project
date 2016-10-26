gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require "minitest/nyan_cat"
require './lib/parser'

class ParserTest < Minitest::Test

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
    assert Parser.new
  end

  def test_it_reads_request_lines
    parser = Parser.new(@get_lines)
    expected = @get_lines
    assert_equal expected, parser.request_lines
  end

  def test_it_returns_get_path_protocol_heading_as_array
    parser = Parser.new(@get_lines)
    expected = ["GET", "/", "HTTP/1.1"]
    assert_equal expected, parser.verb_path_protocol
  end
  
  def test_it_returns_post_path_protocol_heading_as_array
    parser = Parser.new(@post_lines)
    expected = ["POST", "/cgi-bin/process.cgi", "HTTP/1.1"]
    assert_equal expected, parser.verb_path_protocol
  end

  def test_it_returns_get_verb
    parser = Parser.new(@get_lines)
    expected = "GET"
    assert_equal expected, parser.verb
  end

  def test_it_returns_post_verb
    parser = Parser.new(@post_lines)
    expected = "POST"
    assert_equal expected, parser.verb
  end

  def test_it_returns_path
    parser = Parser.new(@get_lines)
    expected = "/"
    assert_equal expected, parser.path
  end

  def test_it_returns_a_different_path
    parser = Parser.new(@post_lines)
    expected = "/cgi-bin/process.cgi"
    assert_equal expected, parser.path
  end

  def test_it_returns_protocol
    parser = Parser.new(@get_lines)
    expected = "HTTP/1.1"
    assert_equal expected, parser.protocol
  end

  def test_it_returns_protocol_for_different_request
    parser = Parser.new(@post_lines)
    expected = "HTTP/1.1"
    assert_equal expected, parser.protocol
  end

  def test_it_returns_host_heading_as_array
    parser = Parser.new(@get_lines)
    expected = ["Host:", "localhost:9292"]
    assert_equal expected, parser.host_heading
  end

  def test_it_returns_host_heading_as_array_for_different_request
    parser = Parser.new(@post_lines)
    expected = ["Host:", "www.tutorialspoint.com"]
    assert_equal expected, parser.host_heading
  end

  def test_it_returns_host 
    parser = Parser.new(@get_lines)
    expected = "localhost"
    assert_equal expected, parser.host
  end

  def test_it_returns_a_different_host
    parser = Parser.new(@post_lines)
    expected = "www.tutorialspoint.com"
    assert_equal expected, parser.host
  end

  def test_it_returns_port
    parser = Parser.new(@get_lines)
    expected = "9292"
    assert_equal expected, parser.port
  end

  def test_it_returns_a_different_port
    parser = Parser.new(@post_lines)
    expected = "N/A"
    assert_equal expected, parser.port
  end

  def test_it_returns_origin
    parser = Parser.new(@get_lines)
    expected = "localhost"
    assert_equal expected, parser.origin
  end

  def test_it_returns_a_different_origin
    parser = Parser.new(@post_lines)
    expected = "www.tutorialspoint.com"
    assert_equal expected, parser.origin
  end

  def test_it_returns_accept
    parser = Parser.new(@get_lines)
    expected = "*/*"
    assert_equal expected, parser.accept
  end

  def test_it_returns_different_accept
    parser = Parser.new(@post_lines)
    expected = "N/A"
    assert_equal expected, parser.accept
  end

  
end