module Rack
  module AMQP
    module Client
      class Manager
        attr_accessor :connection_options, :amqp_channel, :amqp_client

        def initialize(broker_connection_options)
          connect!(broker_connection_options)
          @correlation_id = 0
          @incomplete_requests = []
          @mutex = Mutex.new
        end

        # TODO this method needs to be refactored
        def request(uri, options={})
          http_method = options[:http_method]
          timeout = options[:timeout] || 5

          body = options[:body] || ""
          headers = {
            'Content-Type' => 'application/x-www-form-urlencoded',
            'Content-Length' => body.length
          }.merge(options[:headers])

          request = Request.new((@correlation_id += 1).to_s, http_method, uri, body, headers)
          @mutex.synchronize { @incomplete_requests << request }

          callback_queue = create_callback_queue
          request.callback_queue = callback_queue

          amqp_channel.direct('').publish(request.payload, request.publishing_options)

          if options[:async]
            NullResponse.new
          else
            request.reply_wait(timeout)
          end
        end

        private

        def create_callback_queue
          @callback_queue ||= begin
          # build queue
          queue = amqp_channel.queue("", auto_delete: true, exclusive: true)
          queue.subscribe do |di, meta, payload|
            request = nil
            @mutex.synchronize do 
              request = @incomplete_requests.detect do |r|
                r.request_id == meta[:correlation_id]
              end
              @incomplete_requests.delete(request)
            end
            request.callback(di, meta, payload)
          end
          # bind to an exchange, maybe later
          queue
          end
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
