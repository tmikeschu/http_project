require './lib/path_handler'

class RequestLines
  
  include PathHandler, Parser

  attr_reader :request

  def initialize
    @request = []
  end
  
  def << (line)
    @request << line
    @request.flatten!
  end
  
  

  
end