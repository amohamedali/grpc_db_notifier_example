#!/bin/sh

cd ruby_model_generator && bundle install --path .gems
cd ruby_notifier_server && bundle install --path .gems
cd simpleGRPCWatcherClient && ./generate_jar.sh