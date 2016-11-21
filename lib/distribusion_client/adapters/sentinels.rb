require 'zip'
require 'net/http'
require 'csv'

module DistribusionClient
  module Adapters
    class Sentinels
      attr_accessor(:routes)

      def routes
        uri = URI.parse(DistribusionClient.config.endpoint_url)
        params = { passphrase: DistribusionClient.config.passphrase, source: :sentinels }
        uri.query = URI.encode_www_form(params)

        download_and_parse_data(uri)

        @schedule = []

        route_ids.each do |route_id|
          routes = routes_by_route_id(route_id)
          next if routes.count < 2
          build_schedule(routes)
        end

        @schedule
      end

      private

      def route_ids
        @routes.map { |route| route['route_id'] }.uniq
      end

      def routes_by_route_id(route_id)
        @routes.select { |route| route['route_id'] == route_id }.sort_by { |route| route['index'] }
      end

      def download_and_parse_data(uri)
        Zip::File.open_buffer(Net::HTTP.get(uri)) do |zip|
          zip.each do |entry|
            input_stream = entry.get_input_stream
            next unless input_stream.is_a?(Zip::InputStream)
            next unless entry.name =~ %r{sentinels/routes}
            file_content = CSV.parse(entry.get_input_stream.read, headers: true, col_sep: ', ')
            @routes = file_content
          end
        end
      end

      def build_schedule(routes)
        r1 = routes.shift
        r2 = routes.first
        if r2['index'].to_i - r1['index'].to_i == 1
          @schedule << Route.new(
            source: :sentinels,
            start_node: r1['node'],
            end_node: r2['node'],
            start_time: Time.parse(r1['time']),
            end_time: Time.parse(r2['time'])
          )
        end
        build_schedule(routes) if routes.count > 1
      end
    end
  end
end
