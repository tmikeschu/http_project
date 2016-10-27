class Game

  attr_reader :secret_number, 
              :guesses

  def initialize
    @secret_number = random_number
    @guesses = 0
    @guess
  end

  def random_number
    rand(1..100)
  end

end