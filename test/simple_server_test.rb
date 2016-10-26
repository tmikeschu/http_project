require 'faraday'
gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require "minitest/nyan_cat"
require './lib/simple_server'

class SimpleServerTest < Minitest::Test

  def test_it_gets_homepage
    response = Faraday.get("http://localhost:9292/")
    assert_equal 200, response.status
  end


  
end