#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'bundler/setup'
Bundler.require(:default)
Mongoid.load!("config/mongoid.yml", :development)

require 'logger'

require 'person'

def logger
  # @logger ||= Logger.new(STDOUT)
  @logger ||= Logger.new('log_file.log')
end

def create_person persons
  logger.info("create_person name: test_name#{persons.length} email: test_name#{persons.length}@test.com")
  persons << Model::Person.create!(name: "test_name#{persons.length}", email: "test_name#{persons.length}@test.com")
end

def update_person persons
  if persons.empty?
    create_person persons
  else
    to_update = persons.sample
    logger.info("update_person name: #{to_update.name}")
    to_update.update_attributes!(name: to_update.name + ' updated', email: to_update.email + ' updated')
  end
end

def delete_person persons
  if persons.empty?
    create_person persons
  else
    to_delete = persons.delete(persons.sample)
    logger.info("delete_person name: #{to_delete.name}")
    to_delete.destroy
  end
end


def boot
  srand
  persons = Model::Person.all.to_a
  create_person persons
  update_person persons
  delete_person persons
  until false
    next_action_in = rand(0..43200) # 3600 * 12 = 43200
    case rand(0..2)
    when 0
      create_person persons
    when 1
      update_person persons
    when 2
      delete_person persons
    end

    hour = next_action_in / 3600
    min = (next_action_in - (hour * 3600)) / 60
    second = next_action_in % 60
    logger.info("Action done next action in: #{hour} hour(s) #{min} minute(s) and #{second} second(s)")
    sleep(next_action_in)
  end

end

boot