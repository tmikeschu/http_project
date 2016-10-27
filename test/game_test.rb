gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require "minitest/nyan_cat"
require './lib/game'

class GameTest < Minitest::Test

  def test_it_exists
    assert Game.new
  end

  def test_it_has_a_secret_number
    game = Game.new
    assert_equal Fixnum, game.secret_number.class
  end

  def test_it_is_a_random_number_each_game
    game1 = Game.new
    game2 = Game.new
    refute game1.secret_number == game2.secret_number
  end

  def test_it_initializes_with_guess_count_at_zero
    game = Game.new
    assert_equal 0, game.guesses
  end

  def test_it_starts_with_a_guess

end