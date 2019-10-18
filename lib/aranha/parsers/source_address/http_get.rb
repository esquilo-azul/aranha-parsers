# frozen_string_literal: true

require 'addressable'
require 'curb'

module Aranha
  module Parsers
    class SourceAddress
      class HttpGet
        class << self
          def location_uri(source_uri, location)
            ::Addressable::URI.join(source_uri, location).to_s
          end

          def valid_source?(source)
            source.to_s =~ %r{\Ahttps?://}
          end
        end

        attr_reader :source

        def initialize(source)
          @source = source.to_s
        end

        def ==(other)
          self.class == other.class && source == other.source
        end

        def url
          source
        end

        def content
          c = ::Curl::Easy.new(url)
          raise "Curl perform failed (URL: #{url})" unless c.perform
          return c.body_str if c.status.to_i == 200
          raise "Get #{url} returned #{c.status.to_i}"
        end

        def serialize
          url
        end
      end
    end
  end
end
