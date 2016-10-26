require './lib/parser'

class Diagnostics
  attr_reader :parser
  
  def initialize(request_lines = [])
    @parser = Parser.new(request_lines)
  end

  def diagnosis
    [
      "Verb: #{parser.verb}",
      "Path: #{parser.path}",
      "Protocol: #{parser.protocol}",
      "Host: #{parser.host}",
      "Port: #{parser.port}",
      "Origin: #{parser.origin}",
      "Accept: #{parser.accept}"
    ].join("\n")
  end

end