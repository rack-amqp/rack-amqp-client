module Rack
  module AMQP
    module Client
      class Manager
        attr_accessor :connection_options, :amqp_channel, :amqp_client

        def initialize(broker_connection_options)
          connect!(broker_connection_options)
          @correlation_id = 0
        end

        # TODO bleh method
        def request(uri, options={})
          http_method = options[:http_method]
          timeout = options[:timeout] || 5

          body = options[:body] || ""
          headers = {
            'Content-Type' => 'application/x-www-form-urlencoded',
            'Content-Length' => body.length
          }.merge(options[:headers])

          request = Request.new(@correlation_id += 1, http_method, uri, body, headers)
          callback_queue = create_callback_queue(request.callback)
          request.callback_queue = callback_queue

          amqp_channel.direct('').publish(request.payload, request.publishing_options)

          response = request.reply_wait(timeout)
          response
        end

        private

        def create_callback_queue(cb)
          # build queue
          queue = amqp_channel.queue("", auto_delete: true, exclusive: true)
          queue.subscribe(&cb)
          # bind to an exchange, maybe later
          queue
        end

        def connect!(broker_options)
          self.amqp_client = Bunny.new(broker_options)
          amqp_client.start
          self.amqp_channel = amqp_client.create_channel
        end

      end
    end
  end
end
