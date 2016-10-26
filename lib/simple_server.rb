require 'socket'
require './lib/diagnostics'
require './lib/path_handler'
require './lib/parser'


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
    # something along the lines of make a class wbere request lines is an instance
    # variable and can pull on all the classes as modules that only instantiate 
    # request lines again
    client       = server.accept
    request      = request_lines(client)
    path         = path(request)
    @total_hits += 1

    response = path_content_loader(client, request)
    diag = diagnosis(request)
    
    puts "Sending response."
    output = "<html><head></head><body><pre>#{response}#{diag}</pre></body></html>"
    headers = ["HTTP/1.1 200 OK",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts output
    client.puts headers

    client.close
  end

  def request_lines(client)
    request = []
    while line = client.gets and !line.chomp.empty?
      request << line.chomp
    end
    request
  end

  def path(request)
    Parser.new(request).path
  end

  def path_content_loader(client, request)
    path = path(request)
    "#{handle(path)}"
  end   

  def diagnosis(request) 
    Diagnostics.new(request).diagnosis
  end

end

if __FILE__ == $0
  SimpleServer.new.server_loop
end