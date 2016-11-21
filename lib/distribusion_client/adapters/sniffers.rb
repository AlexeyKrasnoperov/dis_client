require 'zip'
require 'net/http'
require 'csv'

module DistribusionClient
  module Adapters
    class Sniffers
      attr_accessor(:routes, :node_times, :sequences)

      def routes
        uri = URI.parse(DistribusionClient.config.endpoint_url)
        params = { passphrase: DistribusionClient.config.passphrase, source: :sniffers }
        uri.query = URI.encode_www_form(params)

        @schedule = []

        @sequences.each do |sequence|
          route = route_by_id(sequence['route_id'])
          node_time = node_time_by_id(sequence['node_time_id'])
          build_schedule(route, node_time) if route && node_time
        end
        @schedule
      end

      private

      def download_and_parse_data(uri)
        Zip::File.open_buffer(Net::HTTP.get(uri)) do |zip|
          zip.each do |entry|
            input_stream = entry.get_input_stream
            next unless input_stream.is_a?(Zip::InputStream)
            file_content = CSV.parse(entry.get_input_stream.read, headers: true, quote_char: '"', col_sep: ', ')
            case entry.name
            when %r{sniffers/routes}
              @routes = file_content
            when %r{sniffers/node_times}
              @node_times = file_content
            when %r{sniffers/sequences}
              @sequences = file_content
            end
          end
        end
      end

      def route_by_id(route_id)
        @routes.select { |route| route['route_id'] == route_id }.first
      end

      def node_time_by_id(node_time_id)
        @node_times.select { |node_time| node_time['node_time_id'] == node_time_id }.first
      end

      def build_schedule(route, node_time)
        start_time = Time.parse(route['time'] + route['time_zone'])
        @schedule << Route.new(
          source: :sniffers,
          start_node: node_time['start_node'],
          end_node: node_time['end_node'],
          start_time: start_time,
          end_time: start_time + (node_time['duration_in_milliseconds'].to_i / 1000)
        )
      end
    end
  end
end
