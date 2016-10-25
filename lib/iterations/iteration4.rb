require 'socket'

class SimpleServer
  puts "Ready for a request"

  def initialize(port)
    @tcp_server = TCPServer.new(port)
    @hello_hits = 0
    @total_requests = 0
    @counter = 0
    server_loop
  end

  def server_loop
    loop do
      client = @tcp_server.accept

      request_lines = []
      while line = client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end
      
      break if handle_paths(request_lines, client) == "finished"
      # handle_paths(request_lines, client)
      puts "\nResponse complete, exiting (#{@counter += 1})."
      client.close
    end
  end
      
  def request_lines_list(request_lines)
    puts request_lines.join("\n")
  end
  
  def diagnostics(request_lines)
    first_heading = request_lines.first.split
    second_heading = request_lines[1].split(":").map(&:strip)
    accept_heading = request_lines[6].split
    [
      "<pre>", 
      "Verb: #{first_heading[0]}",
      "Path: #{first_heading[1]}",
      "Protocol: #{first_heading[2]}",
      "Host: #{second_heading[1]}",
      "Port: #{second_heading[2]}",
      "Origin: #{second_heading[1]}",
      "Accept: #{accept_heading[1]}",
      "<pre>" 
    ].join("\n")
  end

  def string_query(request_lines)
    request_lines.first.split[1].partition("?")
  end
  
  def handle_paths(request_lines, client)
    case request_lines.first.split[1].partition("?").first
    when "/"
      @total_requests += 1
      client.puts diagnostics(request_lines)
    when "/hello"
      @total_requests += 1
      @hello_hits += 1
      output = "Hello, World! (#{@hello_hits})"
      client.puts "<html><head></head><body>#{output}</body></html>"
      client.puts diagnostics(request_lines)
    when "/datetime"
      @total_requests += 1
      output = "#{Time.now.strftime('%l:%m%p on %A, %B %e, %Y')}"
      client.puts output
      client.puts diagnostics(request_lines)
    when "/word_search"
      @total_requests += 1
      word = string_query(request_lines)[2].partition("=")[2]
      dictionary = File.readlines("/usr/share/dict/words").each(&:strip!)
      if dictionary.include?(word)
        client.puts "#{word.upcase} is a known word"
      else
        client.puts "#{word.upcase} is not a known word"
      end
      client.puts diagnostics(request_lines)    
    when "/shutdown"
      @total_requests += 1
      output = "Total Requests: #{@total_requests}"
      client.puts output
      client.puts diagnostics(request_lines)
      "finished"
    end
  end
   
end

SimpleServer.new(9292)