require './lib/path_handler'
require './lib/diagnostics'


class RequestLines
  
  include PathHandler, Parser, Diagnostics

  attr_reader :request

  def initialize
    @request = []
  end
  
  def << (line)
    @request << line
    @request.flatten!
  end

end