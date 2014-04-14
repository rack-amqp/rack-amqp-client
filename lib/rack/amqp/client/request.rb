#require 'thread'
module Rack
  module AMQP
    module Client
      class Request

        SLEEP_INCREMENT = 

        attr_accessor :routing_key, :request_path, :body, :request_id, :callback_queue, :http_method

        def initialize(request_id, http_method, uri, body, headers={})
          @callback_queue             = callback_queue
          @request_id                 = request_id
          @http_method                = http_method
          @headers                    = headers
          @body                       = body
          @routing_key, @request_path = split_uri uri
          @response                   = nil
          @mutex                      = Mutex.new
          @resource                   = ConditionVariable.new
        end

        def reply_wait(timeout)
          @mutex.synchronize do
            @resource.wait(@mutex, timeout)
          end
          resp = @response
          @reponse = nil
          resp
        end

        def callback
          ->(delivery_info, meta, payload) {
            @mutex.synchronize do
              @resource.signal
              @response = Response.new(meta, payload, delivery_info)
            end
          }
        end


        def publishing_options
          {
            mandatory: true, # receive an error on routing error
            message_id: request_id,
            reply_to: callback_queue.name,
            type: http_method,
            app_id: user_agent,
            timestamp: Time.now.to_i,
            headers: headers,
            routing_key: routing_key
          }
        end

        def payload
          body
        end

        def headers
          @headers.merge(path: request_path)
        end

        def user_agent
          "rack-amqp-client-#{VERSION}"
        end

        def split_uri(uri)
          # expecting target.queue.name/request/path?params=things&others=stuff
          parts = uri.split('/', 2)
          [parts[0].to_s, "/#{parts[1].to_s}"]
        end

      end
    end
  end
end
