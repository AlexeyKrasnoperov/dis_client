require_relative 'distribusion_client/adapters/loopholes'
require_relative 'distribusion_client/adapters/sentinels'
require_relative 'distribusion_client/adapters/sniffers'
require_relative 'distribusion_client/models/route'
require_relative 'distribusion_client/config'
require_relative 'distribusion_client/routes_sender'

module DistribusionClient
  class << self
    def upload_routes
      config.adapters.each do |adapter|
        RoutesSender.new(adapter.new).upload_routes
      end
    end

    def config
      @config ||= Config.new
    end

    def configure
      yield(config)
    end
  end
end
