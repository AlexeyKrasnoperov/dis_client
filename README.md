# Distribusion Client

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'distribusion_client'
```

## Configuration

```ruby
DistribusionClient.configure do |config|
  # default: http://challenge.distribusion.com/the_one/routes
  config.endpoint_url = 'http://challenge.distribusion.com/the_one/routes'
  # ask Cypher for your passphrase
  config.passphrase = 'mypassphrase'
  # default: [DistribusionClient::Adapters::Loopholes, DistribusionClient::Adapters::Sentinels,
  #           DistribusionClient::Adapters::Sniffers]
  config.adapters = [YourAdapter]
end
```

## Usage

```ruby
DistribusionClient.upload_routes
```
