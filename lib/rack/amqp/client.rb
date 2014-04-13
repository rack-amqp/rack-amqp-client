require 'fiber'
require 'amqp'

module Rack
  module AMQP
    module Client
      def self.with_client(*args, &block)
        EventMachine.run do
          Fiber.new {
            yield Manager.new(*args)
            EM.stop
          }.resume
        end
      end

    end
  end
end

require "rack/amqp/client/request"
require "rack/amqp/client/response"
require "rack/amqp/client/manager"
require "rack/amqp/client/version"
