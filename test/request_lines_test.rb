gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require "minitest/nyan_cat"
require './lib/request_lines'

class RequestLinesTest < Minitest::Test

  def setup
    @get_lines = 
      ["GET / HTTP/1.1",
       "Host: localhost:9292",
       "Connection: keep-alive",
       "Cache-Control: no-cache",
       "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
       "Postman-Token: e2095661-c6ca-4ca6-11c6-5feebd9d2bfb",
       "Accept: */*",
       "Accept-Encoding: gzip, deflate, sdch, br",
       "Accept-Language: en-US,en;q=0.8"]

    @post_lines = 
      ["POST /cgi-bin/process.cgi HTTP/1.1", 
       "User-Agent: Mozilla/4.0 (compatible; MSIE5.01; Windows NT)", 
       "Host: www.tutorialspoint.com", 
       "Content-Type: application/x-www-form-urlencoded", 
       "Content-Length: length", "Accept-Language: en-us", 
       "Accept-Encoding: gzip, deflate", 
       "Connection: Keep-Alive"]
  end

  def test_it_exists
    assert RequestLines.new
  end

  def test_request_instance_var_is_an_array
    request = RequestLines.new.request
    assert_equal Array, request.class
  end

  def test_request_shovels_a_line
    request = RequestLines.new
    request << @get_lines[0]
    assert_equal ["GET / HTTP/1.1"], request.request
  end

  def test_request_shovels_two_lines
    request = RequestLines.new
    request << @get_lines[0..1]
    assert_equal ["GET / HTTP/1.1", "Host: localhost:9292"], request.request
  end

  def test_request_shovels_all_lines
    request = RequestLines.new
    request << @get_lines
    assert_equal @get_lines, request.request
  end

  def test_it_uses_verb_path_protocol_method
    request = RequestLines.new
    request << @get_lines
    assert_equal ["GET", "/",  "HTTP/1.1"], request.verb_path_protocol
  end

  def test_verb_method_returns_verb
    request = RequestLines.new
    request << @get_lines
    assert_equal "GET", request.verb
  end

  def test_verb_method_returns_a_different_verb
    request = RequestLines.new
    request << @post_lines
    assert_equal "POST", request.verb
  end

  def test_path_method_returns_path
    request = RequestLines.new
    request << @get_lines
    assert_equal "/", request.path
  end

  def test_path_method_returns_different_path
    request = RequestLines.new
    request << @post_lines
    assert_equal "/cgi-bin/process.cgi", request.path
  end

  def test_protocol_method_returns_protocol
    request = RequestLines.new
    request << @get_lines
    assert_equal "HTTP/1.1", request.protocol
  end
  
  def test_it_returns_host_heading_array
    request = RequestLines.new
    request << @get_lines
    assert_equal ["Host:", "localhost:9292"], request.host_heading
  end

  def test_it_returns_host_name
    request = RequestLines.new
    request << @get_lines
    assert_equal "localhost", request.host
  end

  def test_it_returns_different_host_name
    request = RequestLines.new
    request << @post_lines
    assert_equal "www.tutorialspoint.com", request.host
  end

  def test_it_returns_port_number
    request = RequestLines.new
    request << @get_lines
    assert_equal "9292", request.port
  end

  def test_it_returns_different_port_number
    request = RequestLines.new
    request << @post_lines
    assert_equal "N/A", request.port
  end

  def test_it_returns_origin
    request = RequestLines.new
    request << @get_lines
    assert_equal "localhost", request.origin
  end

  def test_it_returns_different_origin
    request = RequestLines.new
    request << @post_lines
    assert_equal "www.tutorialspoint.com", request.origin
  end

  def test_it_returns_accept_line
    request = RequestLines.new
    request << @get_lines
    assert_equal "*/*", request.accept
  end

  def test_it_returns_different_accept_line
    request = RequestLines.new
    request << @post_lines
    assert_equal "N/A", request.accept
  end

  def test_it_handles_home_path
    request = RequestLines.new
    request << @get_lines
    assert_equal nil, request.handle(0, 1)
  end

  def test_it_handles_hello_path
    request = RequestLines.new
    request << "GET /hello HTTP/1.1"
    expected = "Hello, World! (1)"
    assert_equal expected, request.handle(1, 1)
  end

  def test_it_handles_shutdown_path
    request = RequestLines.new
    request << "GET /shutdown HTTP/1.1"
    expected = "Total Requests: 1"
    assert_equal expected, request.handle(0, 1)
  end

  def test_it_returns_diagnostics
    request = RequestLines.new
    request << @get_lines
    expected = "<pre>\nVerb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: localhost\nPort: 9292\nOrigin: localhost\nAccept: */*\n</pre>"
    assert_equal expected, request.diagnostics
  end

  def test_it_handles_start_game_path
    request = RequestLines.new
    request << "POST /start_game HTTP/1.1"
    expected = "Good luck!"
    assert_equal expected, request.handle(0, 1)
  end
  

end