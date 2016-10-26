require 'faraday'
gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require "minitest/nyan_cat"
require './lib/simple_server'

class SimpleServerTest < Minitest::Test

  def test_it_gets_homepage
    require 'pry'; binding.pry
    response = Faraday.new("http://localhost:9292/")
    assert_equal 0, response

  end

  # def test_host_is_localhost
  #   server = Faraday.new(url)
  #   assert_equal "localhost", server.host
  # end

  # def test_it_has_a_port
  #   server = Faraday.new(url)
  #   assert_equal 9292, server.port
  # end
  
  # def test_it_has_a_path
  #   conn = Faraday.get(url)
  #   require 'pry'; binding.pry
  #   assert_equal "/", conn
  # end

  
end