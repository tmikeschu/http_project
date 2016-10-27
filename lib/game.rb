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
    return "Start a new game!" if @guessed == true
    if number.to_i < secret_number
      guesses[number] = "too low"
    elsif number.to_i > secret_number
      guesses[number] = "too high"
    else
      @guessed = true
      guesses[number] = "correct"
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
    number.to_i.between?(0, 100)
  end

  def last
    guesses.keys.last
  end

  

end