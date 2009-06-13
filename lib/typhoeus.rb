require 'cgi'
require 'digest/sha2'
require 'typhoeus/easy'
require 'typhoeus/multi'
require 'typhoeus/native'
require 'typhoeus/filter'
require 'typhoeus/remote_method'
require 'typhoeus/remote'
require 'typhoeus/remote_proxy_object'
require 'typhoeus/response'

module Typhoeus
  VERSION = "0.0.9"

  def self.easy_object_pool
    @easy_objects ||= []
  end

  def self.init_easy_object_pool
    20.times do
      easy_object_pool << Typhoeus::Easy.new
    end
  end

  def self.release_easy_object(easy)
    easy.reset
    easy_object_pool << easy
  end

  def self.get_easy_object
    if easy_object_pool.empty?
      Typhoeus::Easy.new
    else
      easy_object_pool.pop
    end
  end

  def self.add_easy_request(easy_object)
    Thread.current[:curl_multi] ||= Typhoeus::Multi.new
    Thread.current[:curl_multi].add(easy_object)
  end

  def self.perform_easy_requests
    Thread.current[:curl_multi].perform
  end
end
