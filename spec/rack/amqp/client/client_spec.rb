require 'spec_helper'

describe Rack::AMQP::Client do
  describe '#with_client' do
    it 'yields something' do
      x = nil
      Rack::AMQP::Client::Manager.stub_any_instance(:connect!, nil) do
        Rack::AMQP::Client.with_client({}) do |mgr|
          x = mgr
        end
      end
      refute_nil x
    end
  end
end
