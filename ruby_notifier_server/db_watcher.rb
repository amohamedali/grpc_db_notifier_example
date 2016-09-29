class DbWatcher

  def initialize
    @oplog_queue = Mongoid.client('local_db')['oplog.rs']
    start = @oplog_queue.find({}, { sort: { '$natural' => -1 }}).limit(1).first['ts']

    @filters =  { 'ts' => { '$gt' => start },
                  'ns' => {'$eq' => Model::Person.collection.namespace },
                  'fromMigrate' => { '$exists' => false } }

    @enumerators = []
    # @oplog_queue.find(@filters) do | cursor |
    #   cursor.add_option(Mongo::Constants::OP_QUERY_OPLOG_REPLAY)
    #   cursor.add_option(Mongo::Constants::OP_QUERY_TAILABLE)
    #   cursor.add_option(Mongo::Constants::OP_QUERY_AWAIT_DATA)
    #   @cursor = cursor
    # end
    # p @cursor
  end

  def get_collection
    Model::Person.all.to_a.map do | obj |
      {'o' => obj.attributes }
    end
  end


  def init_push_collection enum
    ServerLogger.instance.logger.info("[DbWatcher] : Pushing initial database state")
    get_collection.each do | item |
      message = DbEventSerializer.new(item).serialize_view
      enum.push(message)
    end
  end

  def collect
    until false do
      @oplog_queue.find(@filters, {flags: [:oplog_replay, :tailable_cursor, :await_data, :no_cursor_timeout]}).each do | op |
        message = DbEventSerializer.new(op).serialize
        @enumerators.each do | enum |
          enum.push(message)
        end
      end
    end
  rescue Exception => e
    p e
    raise e
  end

  def add_enumerator enum
    @enumerators << enum
  end

end