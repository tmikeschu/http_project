require './lib/path_handler'
require './lib/diagnostics'
require './lib/parser'

class RequestLines
  
  include PathHandler, Parser, Diagnostics

  attr_reader :request
  attr_accessor :number_guess

  def initialize
    @request = []
    @number_guess
  end
  
  def << (line)
    request << line
    request.flatten!
  end

end