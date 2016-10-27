require 'faraday'
gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require "minitest/nyan_cat"
require './lib/simple_server'

class SimpleServerTest < Minitest::Test


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

  # test shuts down server
  # def test_it_has_shutdown_path
  #   response = Faraday.get("http://localhost:9292/shutdown")
  #   result = response.body.split("\n").find{|line| line.start_with?("Path:")}
  #   assert_equal "Path: /shutdown", result
  # end

  
end