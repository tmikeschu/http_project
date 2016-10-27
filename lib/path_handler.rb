module PathHandler

  def handle(hello_hits, total_hits, game)
    request = self
    return handle_get(request, hello_hits, total_hits, game) if request.verb == "GET"
    handle_post(request, hello_hits, total_hits, game) if request.verb == "POST"
  end

  def handle_get(request, hello_hits, total_hits, game)
    path    = request.path.partition("?")
    case path.first
    when "/"            then nil
    when "/hello"       then hello +  " (#{hello_hits})"
    when "/datetime"    then datetime
    when "/word_search" then word_search(path)
    when "/game"        then game(game)
    when "/shutdown"    then shutdown + " #{total_hits}"
    end
  end

  def handle_post(request, hello_hits, total_hits, game)
    path    = request.path.partition("?")    
    case path.first
    when "/start_game"  then start_game
    when "/game"        then make_guess(path, game)
    end
  end

  def hello
    "Hello, World!"
  end

  def datetime
    "#{Time.now.strftime('%l:%m%p on %A, %B %e, %Y')}"  
  end

  def word_search(path)
    word  = word(path)
    known = "#{word.upcase} is a known word"
    return known if dictionary.include?(word)
    "#{word.upcase} is not a known word"
  end
  
  def word(path)
    path[2].partition("=")[2]
  end

  def number(request)
    path[2].partition("=")[2]
  end

  def dictionary
    File.readlines("/usr/share/dict/words").each(&:strip!)
  end

  def start_game
    "Good luck!"
  end

  def game(game)
    return "Start a game with POST /start_game!" if game.nil?  
    return "Make a guess!" if game.guesses[game.last].nil?
    return "#{game.last} is correct! Start a new game!" if game.guessed == true
    "Last guess #{"was " + game.last + " and " + game.guesses[game.last]}. Total guesses: #{game.guesses.count}."
  end

  def make_guess(path, game)
    return "Game over. Start a new game!" if game.guessed == true    
    number = number(request)
    game.guess_number(number)
  end

  def shutdown
    "Total Requests:"
  end

end