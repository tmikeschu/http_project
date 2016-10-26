require 'socket'
puts "Ready for a request"

tcp_server = TCPServer.new(9292)
hello_hits = 0
total_requests = 0

loop do
  client = tcp_server.accept

  request_lines = []
  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

  # puts "Got this request:"
  # puts request_lines.join("\n")

  puts "Sending response."
  
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
      "</pre>" 
    ].join("\n")
  end
  output = diagnostics(request_lines)
  client.puts "<html><head></head><body>#{output}</body></html>"

  client.close
  puts "\nResponse complete, exiting."
end
