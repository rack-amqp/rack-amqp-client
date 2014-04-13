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

    #it "passes options it doesn't understand to the AMQP gem" do
    #  @seen_options = nil
    #  expect(::AMQP).to receive(:connect) do |options, &cb|
    #    @seen_options = options.dup # these get clobbered later
    #    cb.call(nil)
    #  end
    #  Rack::AMQP::Client.with_client({foo: 'bar'}) {|m| }
    #  expect(@seen_options).to eq({foo: 'bar'})
    #end
    it "integrates", brittle: true do
      Timeout.timeout(10) do
        Rack::AMQP::Client.with_client(host: 'localhost') do |c|
          response = c.request('test.simple/users.json', {http_method: 'GET', headers: {}})
          expect(response.payload).to eq("[{\"id\":1,\"login\":\"someguy\",\"password\":\"awesomenesssss\",\"created_at\":\"2013-12-07T17:11:45.518Z\",\"updated_at\":\"2013-12-07T17:11:45.518Z\"},{\"id\":2,\"login\":\"Hi\",\"password\":\"There\",\"created_at\":\"2014-03-30T18:31:21.106Z\",\"updated_at\":\"2014-03-30T18:31:21.106Z\"}]")
        end
      end
    end
  end
end
