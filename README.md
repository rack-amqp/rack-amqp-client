# Rack::Amqp::Client

An AMQP-HTTP ruby client that simplifies following convention

## Installation

Add this line to your application's Gemfile:

    gem 'rack-amqp-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-amqp-client

## Usage

```ruby
client = Rack::AMQP::Client.client(host: 'localhost') # host is your AMQP broker, like RabbitMQ or whatever

# First param is the queue and http path, etc; second is options
response = client.request('test.simple/users.json', {http_method: 'GET', headers: {}})

response.payload
# => "[{\"id\":1,\"login\":\"someguy\",\"password\":\"awesomenesssss\",\"created_at\":\"2013-12-07T17:11:45.518Z\",\"updated_at\":\"2013-12-07T17:11:45.518Z\"},{\"id\":2,\"login\":\"Hi\",\"password\":\"There\",\"created_at\":\"2014-03-30T18:31:21.106Z\",\"updated_at\":\"2014-03-30T18:31:21.106Z\"}]"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
