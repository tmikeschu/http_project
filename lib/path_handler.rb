require './lib/parser'

module PathHandler
  def handle(path)
    path = path.partition("?")
    case path.first
    when "/"
    when "/hello"
      "Hello, World! (#{@hello_hits += 1})"
    when "/datetime" 
      "#{Time.now.strftime('%l:%m%p on %A, %B %e, %Y')}"
    when "/word_search"
      word = word(path)
      if dictionary.include?(word)
        "#{word.upcase} is a known word"
      else
        "#{word.upcase} is not a known word"
      end
    when "/shutdown"
      @loop = false
      "Total Requests: #{@total_hits}"
    end
  end

  def word(path)
    path[2].partition("=")[2]
  end

  def dictionary
    File.readlines("/usr/share/dict/words").each(&:strip!)
  end

end