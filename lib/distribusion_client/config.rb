module DistribusionClient
  class Config
    include Virtus.model

    attribute :endpoint_url, String, default: 'http://challenge.distribusion.com/the_one/routes'
    attribute :adapters, Array, default: [
      DistribusionClient::Adapters::Loopholes,
      DistribusionClient::Adapters::Sentinels,
      DistribusionClient::Adapters::Sniffers
    ]
    attribute :passphrase, String, default: 'Kans4s-i$-g01ng-by3-bye'
  end
end
