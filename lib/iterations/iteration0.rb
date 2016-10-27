require 'socket'
puts "Ready for a request"

tcp_server = TCPServer.new(9292)
hello_hits = 0

loop do
  client = tcp_server.accept

  request_lines = []
  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

  puts "\nSending response." 
  
  output = "Hello, World! (#{hello_hits += 1})"
  client.puts "<html><head></head><body>#{output}</body></html>"

  client.close
  puts "\nResponse complete, exiting."
end
