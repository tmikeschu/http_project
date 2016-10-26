require './lib/parser'

module PathHandler
  def handle(path)
    case path
    when "/"
    when "/hello" then "Hello, World! "
    when "/datetime" then "#{Time.now.strftime('%l:%m%p on %A, %B %e, %Y')}"
    when "/word_search"
      @total_requests += 1
      word = string_query(request_lines)[2].partition("=")[2]
      dictionary = File.readlines("/usr/share/dict/words").each(&:strip!)
      if dictionary.include?(word)
        client.puts "#{word.upcase} is a known word"
      else
        client.puts "#{word.upcase} is not a known word"
      end
    when "/shutdown" then "Total Requests: "
    end
  end

end