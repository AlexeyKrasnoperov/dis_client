require 'virtus'
module DistribusionClient
  class Route
    include Virtus.model(strict: true)

    attribute :source, String
    attribute :start_node, String
    attribute :end_node, String
    attribute :start_time, Time
    attribute :end_time, Time
  end
end
