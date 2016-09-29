class EnumeratorQueue
  extend Forwardable
  def_delegators :@q, :push, :pop, :length

  def initialize
    @q = Queue.new
  end

  def each
    return enum_for(:each).lazy unless block_given?
    until false
      yield @q.pop
    end
  end

end
