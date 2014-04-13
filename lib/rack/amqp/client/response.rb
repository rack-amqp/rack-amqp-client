module Rack
  module AMQP
    module Client
      class Response

        attr_accessor :meta, :payload, :delivery_info
        def initialize(meta, payload, delivery_info)
          @meta          = meta
          @payload       = payload
          @delivery_info = delivery_info
        end

        def headers
          meta[:headers]
        end

        def response_code
          headers['X-AMQP-HTTP-Status']
        end
      end
    end
  end
end

