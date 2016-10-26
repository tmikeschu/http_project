class Parser
  
  attr_reader :request_lines

  def initialize(request_lines = [])
    @request_lines = request_lines
  end

  def verb_path_protocol
    request_lines.find do |line| 
      line.start_with?("GET") || line.start_with?("POST")
    end.split
  end

  def verb 
    verb_path_protocol[0]
  end

  def path
    verb_path_protocol[1]
  end

  def protocol
    verb_path_protocol[2]
  end

  def host_heading
    request_lines.find {|line| line.start_with?("Host")}.split
  end

  def host 
    host_heading[1].split(":")[0]
  end

  def port
    port = host_heading[1].split(":")[1]
    if port.nil?
      "N/A" 
    else
      port
    end
  end

  def origin
    host_heading[1].split(":")[0]
  end

  def accept
    accept = request_lines.find {|line| line.start_with?("Accept:")}
    if accept
      accept.split[1] 
    else
      "N/A"
    end
  end
    


end