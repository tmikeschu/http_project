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

  def test_gueses_starts_as_an_empty_hash
    game = Game.new
    assert_equal ({}), game.guesses
  end

  def test_it_initializes_with_guess_count_at_zero
    game = Game.new
    assert_equal 0, game.guesses.count
  end

  def test_it_takes_a_guess
    game = Game.new
    assert game.guess_number(50)
  end
  
  def test_it_stores_guess_with_comparison_in_hash
    game = Game.new
    number = 50
    game.guess_number(number)
    assert_equal String, game.guesses[number].class
  end

  def test_it_stores_lower_boundary_guess
    game = Game.new
    number = 0
    game.guess_number(number)
    assert game.guesses[number]
  end

  def test_it_stores_upper_boundary_guess
    game = Game.new
    number = 100
    game.guess_number(number)
    assert game.guesses[number]
  end

  def test_it_rejects_a_guess_below_lower_boundary
    game = Game.new
    number = -1
    game.guess_number(number)
    refute game.guesses[number]
  end

  def test_it_rejects_a_guess_above_upper_boundary
    game = Game.new
    number = 101
    game.guess_number(number)
    refute game.guesses[number]
  end

  def test_it_returns_error_if_guess_is_over_100
    game = Game.new
    error = "Error. Enter positive numbers between 0 and 100 only!"
    assert_equal error, game.guess_number(150)
  end

  def test_it_returns_error_if_guess_is_negative
    game = Game.new
    error = "Error. Enter positive numbers between 0 and 100 only!"    
    assert_equal error, game.guess_number(-1)
  end

  def test_it_returns_error_if_guess_is_not_numeric
    game = Game.new
    error = "Error. Enter positive numbers between 0 and 100 only!"    
    assert_equal error, game.guess_number("1s2")
  end

  def test_it_returns_error_if_guess_is_not_numeric_with_capital_letter
    game = Game.new
    error = "Error. Enter positive numbers between 0 and 100 only!"    
    assert_equal error, game.guess_number("1M2")
  end

  def test_it_stores_multiple_guesses_with_comparisons_in_hash
    game = Game.new
    number1 = 50
    number2 = 25
    number3 = 75
    game.guess_number(number1)
    game.guess_number(number2)
    game.guess_number(number3)
    assert_equal String, game.guesses[number2].class
    assert_equal String, game.guesses[number3].class
  end

  def test_it_compares_guess_to_secret
    game = Game.new
    number = 50
    game.guess_number(number)
    assert "too low" || "too high" || "correct" == game.guesses[number]
  end
  
  def test_it_compares_different_guess_to_secret
    game = Game.new
    number = 75
    game.guess_number(number)
    assert "too low" || "too high" || "correct" == game.guesses[number]
  end

  def test_it_returns_most_recent_guess
    game = Game.new
    number1 = 75
    number2 = 50
    number3 = 25        
    game.guess_number(number1)
    game.guess_number(number2)
    assert_equal 50, game.last
    game.guess_number(number3)    
    assert_equal 25, game.last
  end

  def test_it_knows_how_many_guesses_have_been_taken_after_one_guess
    game = Game.new
    game.guess_number(50)
    assert_equal 1, game.guesses.count
  end

  def test_it_knows_how_many_guesses_have_been_taken_after_three_guesses
    game = Game.new
    game.guess_number(75)
    game.guess_number(25)
    game.guess_number(50)
    assert_equal 3, game.guesses.count
  end

end