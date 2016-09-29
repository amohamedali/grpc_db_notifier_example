#Db Notifier Example

To setup the example you can execute the setup.sh script.

## Ruby Model Generator

Creates database events for the Ruby Notifier Server to use

binary: ruby_model_generator/ruby_model_generator.rb


## Ruby Notifier Server

Grpc server that watches the mongodb database and sends events to clients

binary: ruby_notifier_server/db_notifier.rb

## simpleGRPCWatcherClient

Grpc client that prints events received from the DB Notifier

requirements: java (tested with openjdk-8), maven
compile: simpleGRPCWatcherClient/generate_jar.sh
binary: simpleGRPCWatcherClient/run_jar.sh

## Special requirements

Mongodb must [enable oplog on a standalone server](http://stackoverflow.com/questions/20487002/oplog-enable-on-standalone-mongod-not-for-replicaset)

Protobuf for ruby is already generated and included but you can regenerate it using the ruby_generate_protos script