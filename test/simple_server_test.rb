require 'faraday'
gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require "minitest/nyan_cat"
require './lib/simple_server'

class SimpleServerTest < Minitest::Test

  # --seed 19346

  def test_it_has_200_status
    response = Faraday.get("http://localhost:9292/")
    assert_equal 200, response.status
  end

  def test_it_has_verb_get
    response = Faraday.get("http://localhost:9292/")
    result = response.body.split("\n").find{|line| line.start_with?("Verb:")}
    assert_equal "Verb: GET", result
  end

  def test_it_has_home_path
    response = Faraday.get("http://localhost:9292/")
    result = response.body.split("\n").find{|line| line.start_with?("Path:")}
    assert_equal "Path: /", result
  end

  def test_it_has_hello_path
    response = Faraday.get("http://localhost:9292/hello")
    result = response.body.split("\n").find{|line| line.start_with?("Path:")}
    assert_equal "Path: /hello", result
  end

  def test_it_has_datetime_path
    response = Faraday.get("http://localhost:9292/datetime")
    result = response.body.split("\n").find{|line| line.start_with?("Path:")}
    assert_equal "Path: /datetime", result
  end

  def test_it_has_shutdown_path
    response = Faraday.get("http://localhost:9292/shutdown")
    result = response.body.split("\n").find{|line| line.start_with?("Path:")}
    assert_equal "Path: /shutdown", result
  end

  # def test_it_has_correct_diagnostic
  #   response = Faraday.get("http://localhost:9292/shutdown")
  #   expected = 
  #     ["GET / HTTP/1.1",
  #      "Host: localhost:9292",
  #      "Connection: keep-alive",
  #      "Cache-Control: no-cache",
  #      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
  #      "Postman-Token: e2095661-c6ca-4ca6-11c6-5feebd9d2bfb",
  #      "Accept: */*",
  #      "Accept-Encoding: gzip, deflate, sdch, br",
  #      "Accept-Language: en-US,en;q=0.8"]
  #   result = response.body.split("\n")
  #   assert_equal expected, result
  # end
  
end