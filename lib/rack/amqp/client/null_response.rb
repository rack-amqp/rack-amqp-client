module Rack
  module AMQP
    module Client
      class NullResponse < Response
        def initialize(meta = {}, payload = {}, delivery_info = nil)
          super
          @meta[:headers] ||= {}
          @meta[:headers]['X-AMQP-HTTP-Status'] = 200
        end
      end
    end
  end
end


