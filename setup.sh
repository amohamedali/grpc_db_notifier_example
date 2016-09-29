#!/bin/sh

cd ruby_model_generator && bundle install --path .gems; cd ../
cd ruby_notifier_server && bundle install --path .gems; cd ../
cd simpleGRPCWatcherClient && ./generate_jar.sh; cd ../