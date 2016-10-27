module PathHandler

  def handle(hello_hits, total_hits)
    path = self.path.partition("?")
    case path.first
    when "/"            then nil
    when "/hello"       then hello +  " (#{hello_hits})"
    when "/datetime"    then datetime
    when "/word_search" then word_search(path)
    when "/shutdown"    then shutdown + " #{total_hits}"
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

  def dictionary
    File.readlines("/usr/share/dict/words").each(&:strip!)
  end

  def shutdown
    "Total Requests:"
  end

end