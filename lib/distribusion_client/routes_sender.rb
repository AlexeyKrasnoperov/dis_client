require 'net/http'

module DistribusionClient
  class RoutesSender
    def initialize(adapter)
      @adapter = adapter
    end

    def upload_routes
      uri = URI(DistribusionClient.config.endpoint_url)
      @adapter.routes.each do |route|
        res = Net::HTTP.post_form(
          uri,
          passphrase: DistribusionClient.config.passphrase,
          source: route.source,
          start_node: route.start_node,
          end_node: route.end_node,
          start_time: format_time(route.start_time),
          end_time: format_time(route.end_time)
        )
        p route
        p res.body
      end
    end

    private

    def format_time(time)
      time.utc.iso8601.delete('Z')
    end
  end
end
