require 'socket'
require './lib/diagnostics'
require './lib/path_handler'
require './lib/parser'
require './lib/request_lines'



class SimpleServer
  include PathHandler

  attr_reader :server, 
              :loop,
              :hello_hits,
              :total_hits

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
      puts "Response complete. \n"    
    end
  end

  def run_request_response_cycle
    client       = server.accept
    request      = request_lines(client)
    path         = request.path
    @total_hits += 1

    path_content_loader(client, request)
    client.puts request.diagnostics
    client.close
  end

  def request_lines(client)
    request = RequestLines.new
    while line = client.gets and !line.chomp.empty?
      request << line.chomp
    end
    request
  end

  def path_content_loader(client, request)
    client.puts "<html><head></head><body>#{request.handle}</body></html>"
  end   


end

if __FILE__ == $0
  SimpleServer.new.server_loop
end