require 'bunny'

module Rack
  module AMQP
    module Client
      def self.with_client(*args, &block)
        yield Manager.new(*args)
      end

      def self.client(*args)
        Manager.new(*args)
      end

    end
  end
end

require "rack/amqp/client/request"
require "rack/amqp/client/response"
require "rack/amqp/client/manager"
require "rack/amqp/client/version"
