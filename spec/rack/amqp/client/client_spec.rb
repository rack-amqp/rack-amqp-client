require 'spec_helper'
require 'pry'

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

    it "passes options it doesn't understand to the AMQP gem" do
      @seen_options = nil
      expect(::AMQP).to receive(:connect) do |options, &cb|
        @seen_options = options.dup # these get clobbered later
        cb.call(nil)
      end
      Rack::AMQP::Client.with_client({foo: 'bar'}) {|m| }
      expect(@seen_options).to eq({foo: 'bar'})
    end
  end
end
