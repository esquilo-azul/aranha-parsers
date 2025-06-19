# frozen_string_literal: true

require 'addressable'

require 'eac_envs/http/error'
require 'eac_envs/http/request'

module Aranha
  module Parsers
    class SourceAddress
      class HttpGet < ::Aranha::Parsers::SourceAddress::Base
        class << self
          def location_uri(source_uri, location)
            ::Addressable::URI.join(source_uri, location).to_s
          end
        end

        common_constructor :source, super_args: -> { [source.to_s] }

        def ==(other)
          self.class == other.class && source == other.source
        end

        def final_url
          content unless @final_url
          @final_url
        end

        # @return [String]
        # @raise [Aranha::Parsers::SourceAddress::FetchContentError]
        def content
          request = ::EacEnvs::Http::Request.new.url(url).retry(true).follow_redirect(true)
                      .header('user-agent', self.class.name)
          request.response.body_str!
        rescue ::EacEnvs::Http::Error => e
          raise ::Aranha::Parsers::SourceAddress::FetchContentError.new(e.message, request)
        end

        def serialize
          url
        end

        # @return [Addressable::URI]
        def uri
          source_as_uri
        end

        # @return [Boolean]
        def valid?
          source.to_s =~ %r{\Ahttps?://}
        end
      end
    end
  end
end
