class Game

  attr_reader   :secret_number, 
                :guesses

  attr_accessor :guess, 
                :guessed

  def initialize
    @secret_number = random_number
    @guesses = {}
    @guess = nil
    @guessed = false
  end

  def random_number
    rand(0..100)
  end
  
  def guess_number(number)
    return errors(number) if errors(number)
    if number < secret_number
      guesses[number] = "too low"
    elsif number > secret_number
      guesses[number] = "too high"
    else
      guesses[number] = "correct"
      guessed = true
    end
  end

  def errors(number)
    error = "Error. Enter positive numbers between 0 and 100 only!" 
    error unless all_numbers?(number) && in_range?(number)
  end

  def all_numbers?(number)
    number.to_s.chars.all? {|num| num.between?("0", "9")}
  end

  def in_range?(number)
    number.between?(0, 100)
  end

  def last
    guesses.keys.last
  end

  

end