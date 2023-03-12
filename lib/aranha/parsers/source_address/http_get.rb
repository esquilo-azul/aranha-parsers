# frozen_string_literal: true

require 'addressable'
require 'aranha/parsers/source_address/fetch_content_error'
require 'faraday'
require 'faraday/retry'

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

        def final_url
          content unless @final_url
          @final_url
        end

        def content
          conn = ::Faraday.new do |f|
            f.request :retry # retry transient failures
            f.response :follow_redirects # follow redirects
          end
          c = conn.get(url)
          return c.body if c.status == 200

          raise ::Aranha::Parsers::SourceAddress::FetchContentError,
                "Get #{url} returned #{c.status.to_i}"
        end

        def serialize
          url
        end
      end
    end
  end
end
