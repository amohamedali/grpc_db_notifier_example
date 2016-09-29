require 'enumerator_queue'

class DbNotifierServer < Test::DbWatcherService::Service
  include Singleton

  def initialize
    ServerLogger.instance.logger.info("[GRPC][DbNotifierServer] : Instantiating server")
    @watcher = DbWatcher.new
    @watcher_job = Thread.new { @watcher.collect }
  end

  def watch msg, _ctx
    q = EnumeratorQueue.new

    ServerLogger.instance.logger.info("[GRPC][DbNotifierServer] : Received New request #{msg}")

    @watcher.add_enumerator(q)
    @watcher.init_push_collection(q)

    q.each
  rescue Exception => e
    ServerLogger.instance.logger.info(e)
    raise e
  end


end