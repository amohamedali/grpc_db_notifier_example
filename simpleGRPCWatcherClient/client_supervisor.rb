#!/usr/bin/env ruby

require 'logger'
require 'singleton'


class ClientSupervisor
  include Singleton

  TIME_LAPSE = 3600 * 1
  CLIENT_PER_CYCLE = 4
  MAX_CLIENT_PER_CYCLE = CLIENT_PER_CYCLE * 2
  MAX_CONNECTION_FAILS = 1

  def boot
    @logger = Logger.new(STDOUT)
    # @logger = Logger.new('logs/client_supervisor.log')
    @connection_fails = 0
    main_loop
  end

  def main_loop
    begin
      @all_clients = []
      @clients_threads = []
      @client_cnt = 0
      loop do
        @logger.info('starting new cycle')
        @in_cycle = true
        spawn_clients_regularly
        @in_cycle = false
        @logger.info("cycle ended with #{@all_clients.length} client(s) alive")
        kill_all_clients
      end
    rescue RuntimeError => e
      @logger.info(e)
      @connection_fails = @connection_fails + 1
      kill_all_clients
      retry unless @connection_fails >= MAX_CONNECTION_FAILS
    end
  end

  def spawn_clients_regularly
    nb_clients = 0
    while nb_clients < CLIENT_PER_CYCLE
      spawn_new_client
      sleep(TIME_LAPSE)
      nb_clients = nb_clients + 1
    end
  end

  def spawn_new_client
    @logger.info("spawninig new client")
    pid = Process.fork do
      boot_watcher_client
    end
    @logger.info("new client spawned pid: #{pid}")
    @all_clients << pid
    @client_cnt = @client_cnt + 1
    thr = Thread.new do
      Process.wait(pid)
      if @in_cycle
        @logger.info("client with pid: #{pid} crashed during cycle")
        spawn_new_client unless @all_clients.length > MAX_CLIENT_PER_CYCLE
      end
    end
    @clients_threads << thr
  end

  def kill_all_clients
    @logger.info("killing alive clients #{@all_clients}")
    @all_clients.each { | client_pid | Process.kill('TERM', client_pid) }
    @clients_threads.each { |thr| thr.join }
    @all_clients.clear
    @clients_threads.clear
  end

  def boot_watcher_client
    `./run_jar.sh 1>> logs/client.#{@client_cnt}.log 2>&1`
  end

end

ClientSupervisor.instance.boot