require 'bunny'
require 'singleton'

module Rack
  module AMQP
    module Client

      def self.with_client(*args, &block)
        yield client(*args)
      end

      def self.client(*args)
        Synchronizer.instance.client(*args)
      end

      class Synchronizer
        include Singleton
        def initialize
          @mutex = Mutex.new
          super
        end

        def client(*args)
          @mutex.synchronize do # TODO this probably doesn't help anything here
            @mgr ||= Manager.new(*args)
          end
        end
      end

    end
  end
end

require "rack/amqp/client/request"
require "rack/amqp/client/response"
require "rack/amqp/client/manager"
require "rack/amqp/client/version"
