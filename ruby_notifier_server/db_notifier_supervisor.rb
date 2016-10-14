#!/usr/bin/env ruby

class DbNotifierSupervisor

  TIME_LAPSE = 3600 * 4

  def self.main_loop
    loop do
      @pid = Process.fork do
        boot_db_notifier
      end
      sleep(TIME_LAPSE)
      Process.kill('TERM', @pid)
    end
  end

  def self.boot_db_notifier
    `./db_notifier.rb`
  end

end

DbNotifierSupervisor.main_loop