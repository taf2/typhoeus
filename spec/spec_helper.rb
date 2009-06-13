require "rubygems"
require "spec"
$:.unshift File.join(File.dirname(__FILE__),'..','ext')
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

# gem install redgreen for colored test output
begin require "redgreen" unless ENV['TM_CURRENT_LINE']; rescue LoadError; end

require "lib/typhoeus"

# local servers for running tests
require File.dirname(__FILE__) + "/servers/method_server.rb"

def start_method_server(port, sleep = 0)
  MethodServer.sleep_time = sleep
  pid = Process.fork do
    EventMachine::run {
      EventMachine.epoll
      EventMachine::start_server("0.0.0.0", port, MethodServer)
    }
  end
  sleep 0.2
  pid
end

def stop_method_server(pid)
  Process.kill("HUP", pid)
end
