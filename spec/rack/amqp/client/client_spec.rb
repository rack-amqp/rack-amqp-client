require 'spec_helper'

describe Rack::AMQP::Client do
  describe '#with_client' do
    it 'yields something' do
      x = nil
      Rack::AMQP::Client::Manager.any_instance.stub(:connect!).and_return(nil)
      Rack::AMQP::Client.with_client({}) do |mgr|
        x = mgr
      end
      expect(x).to_not be_nil
    end
  end
end
