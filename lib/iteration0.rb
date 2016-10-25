require 'socket'
# require 'pry'; binding.pry
puts "Ready for a request"

tcp_server = TCPServer.new(9292)
hello_hits = 0

loop do 
  client = tcp_server.accept

  request_lines = []
  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

  puts "Got this request:"
  puts request_lines.inspect


  puts "Sending response."
  first_heading = request_lines.first.split

  if first_heading[1] == "/hello"
    hello_hits += 1
    output = "Hello, World! (#{hello_hits})"
    client.puts "<html><head></head><body>#{output}</body></html>"
  end
    client.close
    puts "\nResponse complete, exiting."
end
