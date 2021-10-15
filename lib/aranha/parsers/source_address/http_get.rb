# frozen_string_literal: true

require 'addressable'
require 'curb'
require 'aranha/parsers/source_address/fetch_content_error'

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
          c = ::Curl::Easy.new(url)
          c.follow_location = true
          curl_perform(c)
          return c.body_str if c.status.to_i == 200

          raise ::Aranha::Parsers::SourceAddress::FetchContentError,
                "Get #{url} returned #{c.status.to_i}"
        end

        def serialize
          url
        end

        private

        def curl_perform(curl)
          unless curl.perform
            raise(::Aranha::Parsers::SourceAddress::FetchContentError,
                  "Curl perform failed (URL: #{url})")
          end
          @final_url = curl.url
        rescue Curl::Err::CurlError => e
          raise ::Aranha::Parsers::SourceAddress::FetchContentError, "CURL error: #{e.class.name}"
        end
      end
    end
  end
end
