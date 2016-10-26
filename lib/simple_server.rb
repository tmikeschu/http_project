require 'socket'
require './lib/path_handler'
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
    @hello_hits += 1 if hello?(request.path)
    @total_hits += 1

    content      = request.handle(@hello_hits, @total_hits)
    diagnostics  = request.diagnostics 
    body         = []

    body << content << diagnostics

    puts "Sending response."
    response = body.join("\n")
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output
    @loop = false if shutdown?(request.path)
    client.close
  end

  def hello?(path)
    path == "/hello"
  end

  def shutdown?(path)
    path == "/shutdown"
  end

  def request_lines(client)
    request = RequestLines.new
    while line = client.gets and !line.chomp.empty?
      request << line.chomp
    end
    request
  end   


end

if __FILE__ == $0
  SimpleServer.new.server_loop
end