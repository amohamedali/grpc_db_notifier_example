# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: dbWatcher.proto for package 'test'

require 'grpc'
require 'dbWatcher_pb'

module Test
  module DbWatcherService
    class Service

      include GRPC::GenericService

      self.marshal_class_method = :encode
      self.unmarshal_class_method = :decode
      self.service_name = 'test.DbWatcherService'

      rpc :watch, DbWatchRequest, stream(DbEvent)
    end

    Stub = Service.rpc_stub_class
  end
end