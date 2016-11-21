require 'zip'
require 'net/http'
require 'json'

module DistribusionClient
  module Adapters
    class Loopholes
      attr_accessor(:routes, :node_pairs)

      def routes
        uri = URI.parse(DistribusionClient.config.endpoint_url)
        params = { passphrase: DistribusionClient.config.passphrase, source: :loopholes }
        uri.query = URI.encode_www_form(params)

        download_and_parse_data(uri)
        build_routes
      end

      private

      def build_routes
        @routes.map do |route|
          node_pair = node_pair_by_id(route['node_pair_id'])
          next unless node_pair
          Route.new(
            source: :loopholes,
            start_node: node_pair['start_node'],
            end_node: node_pair['end_node'],
            start_time: Time.parse(route['start_time']),
            end_time: Time.parse(route['end_time'])
          )
        end.compact
      end

      def download_and_parse_data(uri)
        Zip::File.open_buffer(Net::HTTP.get(uri)) do |zip|
          zip.each do |entry|
            input_stream = entry.get_input_stream
            next unless input_stream.is_a?(Zip::InputStream)
            file_content = JSON.parse!(entry.get_input_stream.read, headers: true, col_sep: ', ')
            case entry.name
            when %r{loopholes/routes}
              @routes = file_content['routes']
            when %r{loopholes/node_pairs}
              @node_pairs = file_content['node_pairs']
            end
          end
        end
      end

      def node_pair_by_id(node_pair_id)
        @node_pairs.select { |node_pair| node_pair['id'] == node_pair_id }.first
      end
    end
  end
end
