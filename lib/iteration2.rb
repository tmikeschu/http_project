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
      "<pre>" 
    ].join("\n")
  end
  
  case request_lines.first.split[1]
  when "/"
    total_requests += 1
    client.puts diagnostics(request_lines)
  when "/hello"
    total_requests += 1
    hello_hits += 1
    output = "Hello, World! (#{hello_hits})"
    client.puts "<html><head></head><body>#{output}</body></html>"
    client.puts diagnostics(request_lines)
  when "/datetime"
    total_requests += 1
    output = "#{Time.now.strftime('%l:%m%p on %A, %B %e, %Y')}"
    client.puts output
    client.puts diagnostics(request_lines)
  when "/shutdown"
    total_requests += 1
    output = "Total Requests: #{total_requests}"
    client.puts output
    client.puts diagnostics(request_lines)
    break
  end

  client.close
  puts "\nResponse complete, exiting."
end
