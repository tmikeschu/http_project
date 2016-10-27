require 'socket'
require './lib/request_lines'
require './lib/game'


class SimpleServer

  attr_reader :server,
              :request, 
              :client,
              :loop,
              :hello_hits,
              :total_hits
  attr_accessor :game

  def initialize(port = 9292)
    @server     = TCPServer.new(port)
    @loop       = true
    @hello_hits = 0
    @total_hits = 0
  end

  def server_loop
    while @loop do
      puts "\nWaiting for request..."
      run_request_response_cycle
      puts "Response complete for '#{request.path}' path. \n"    
    end
  end

  def run_request_response_cycle
    @client  = server.accept
    @request = request_lines
    check_for_content_length
    counter_and_switch_update
    check_for_game
    output_and_header_to_view
    client.close
  end

  def request_lines
    request = RequestLines.new
    while line = client.gets and !line.chomp.empty?
      request << line.chomp
    end
    request
  end 

  def check_for_content_length
    content_length = @request.request.find{|line| line.start_with?("Content-Length")}
    return if content_length.nil?
    # require 'pry'; binding.pry
    content_length = content_length.split[1].to_i
    if content_length > 0
      number = client.read(content_length).split("=")[1].to_i
      @request.number_guess = number
    end
  end
  
  def counter_and_switch_update
    @total_hits += 1
    @hello_hits += 1     if request.path == "/hello"
    @loop        = false if request.path == "/shutdown"
  end

  def check_for_game
    return start_game  if request.verb == "POST" && request.path == "/start_game"
  end

  def start_game
    @game = Game.new
  end

  def output_and_header_to_view
    client.puts headers
    client.puts output
  end

  def headers
    if request.verb == "POST" && request.path.start_with?("/game")
      ["http/1.1 301 Moved Permanently",
      "Location: http://localhost:9292/game",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",].join("\r\n")
    else
      ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    end
  end

  def output
    "<html><head></head><body>#{response}</body></html>"
  end

  def response
    body.join("\n")
  end

  def body
    [content,  diagnostics]
  end

  def content
    request.handle(hello_hits, total_hits, game)
  end    

  def diagnostics
    request.diagnostics
  end

end

if __FILE__ == $0
  SimpleServer.new.server_loop
end