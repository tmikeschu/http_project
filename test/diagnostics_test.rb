gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require "minitest/nyan_cat"
require './lib/diagnostics'

class DiagnosticsTest < Minitest::Test
  
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
    assert Diagnostics.new
  end

  def test_it_returns_diagnosis
    diagnosis = Diagnostics.new(@get_lines).diagnosis
    expected = "<pre>\nVerb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: localhost\nPort: 9292\nOrigin: localhost\nAccept: */*\n</pre>"
    assert_equal expected, diagnosis
  end
end