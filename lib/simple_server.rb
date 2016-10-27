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
    client  = server.accept
    request = request_lines(client)
    counter_and_switch_update(request)
    output_and_header_to_view(client, request)
    client.close
  end

  def request_lines(client)
    request = RequestLines.new
    while line = client.gets and !line.chomp.empty?
      request << line.chomp
    end
    request
  end 

  def output_and_header_to_view(client, request)
    client.puts headers(request)
    client.puts output(request)
  end

  def counter_and_switch_update(request)
    @total_hits += 1
    check_for_shut_down(request)
    check_for_hello(request) 
  end

  def check_for_shut_down(request)
    @loop = false if request.path == "/shutdown"
  end

  def headers(request)
    ["http/1.1 200 ok",
    "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
    "server: ruby",
    "content-type: text/html; charset=iso-8859-1",
    "content-length: #{output(request).length}\r\n\r\n"].join("\r\n")
  end

  def output(request)
    "<html><head></head><body>#{response(request)}</body></html>"
  end

  def response(request)
    body(request).join("\n")
  end

  def body(request)
    [content(request),  diagnostics(request)]
  end

  def content(request)
    request.handle(@hello_hits, @total_hits)
  end    

  def diagnostics(request)
    request.diagnostics
  end

  def check_for_hello(request)
    @hello_hits += 1 if request.path == "/hello"
  end

    


end

if __FILE__ == $0
  SimpleServer.new.server_loop
end