require 'logger'

class ServerLogger
  include Singleton
  attr_accessor :logger

  def initialize
    @logger = Logger.new(STDOUT)
    # @logger = Logger.new('logfile.log')
  end

end
