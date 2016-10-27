module Parser
  
  def verb_path_protocol
    @request.find do |line| 
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
    @request.find {|line| line.start_with?("Host")}.split
  end

  def host 
    host_heading[1].split(":")[0]
  end

  def port
    port = host_heading[1].split(":")[1]
    return "N/A" if port.nil? 
    port
  end

  def origin
    host_heading[1].split(":")[0]
  end

  def accept
    accept = @request.find {|line| line.start_with?("Accept:")}
    return "N/A" if accept.nil?
    accept.split[1]
  end
    


end