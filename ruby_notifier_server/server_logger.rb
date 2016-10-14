require 'logger'

class ServerLogger
  include Singleton
  attr_accessor :logger

  def initialize
    # @logger = Logger.new(STDOUT)
    @logger = Logger.new('log_file.log')
  end

end
