#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'bundler/setup'
Bundler.require(:default)
Mongoid.load!("config/mongoid.yml", :development)

require 'dbWatcher_pb'
require 'dbWatcher_services_pb'

require 'db_event_serializer'
require 'server_logger'
require 'person'
require 'db_watcher'
require 'db_notifier_server'


class DbNotifier
  def self.boot
    logger = ServerLogger.instance.logger

    logger.info("[Boot][Mongo] connecting to diffrent shards")

    s = GRPC::RpcServer.new(pool_size: 10)

    host = 'localhost:50052'

    s.add_http2_port(host, :this_port_is_insecure)
    logger.info("[Boot][GRPC] running insecurely on #{host}")

    s.handle(DbNotifierServer.instance)
    s.run_till_terminated
  end
end

DbNotifier.boot