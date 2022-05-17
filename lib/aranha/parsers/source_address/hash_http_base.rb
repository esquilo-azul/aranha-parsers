# frozen_string_literal: true

require 'aranha/parsers/source_address/fetch_content_error'
require 'aranha/parsers/source_address/hash_http_base'
require 'eac_ruby_utils/core_ext'
require 'faraday_middleware'
require 'yaml'

module Aranha
  module Parsers
    class SourceAddress
      class HashHttpBase
        class << self
          def http_method
            const_get 'HTTP_METHOD'
          end

          def valid_source?(source)
            source.is_a?(::Hash) &&
              source.with_indifferent_access[:method].to_s.downcase.strip == http_method.to_s
          end
        end

        DEFAULT_BODY = ''
        DEFAULT_FOLLOW_REDIRECT = true
        DEFAULT_HEADERS = {}.freeze
        DEFAULT_PARAMS = {}.freeze

        enable_simple_cache

        common_constructor :source do
          self.source = source.with_indifferent_access
        end
        compare_by :source

        def body
          param(:body, DEFAULT_BODY)
        end

        def follow_redirect?
          param(:follow_redirect, DEFAULT_FOLLOW_REDIRECT)
        end

        def headers
          param(:headers, DEFAULT_HEADERS)
        end

        def url
          source.fetch(:url)
        end

        def serialize
          source.to_yaml
        end

        # @return [Faraday]
        def faraday_connection
          ::Faraday.new do |f|
            f.response :follow_redirects if follow_redirect?
          end
        end

        def content
          req = faraday_request
          return req.body if req.status == 200

          raise ::Aranha::Parsers::SourceAddress::FetchContentError,
                "Get #{url} returned #{req.status.to_i}"
        end

        def param(key, default_value)
          source[key] || params[key] || default_value
        end

        def params
          source[:params].if_present(DEFAULT_PARAMS)
        end

        private

        def faraday_request_uncached
          faraday_connection.send(self.class.http_method, url) do |req|
            headers.if_present { |v| req.headers = v }
            body.if_present { |v| req.body = v }
          end
        end
      end
    end
  end
end
