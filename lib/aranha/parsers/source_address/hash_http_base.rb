# frozen_string_literal: true

require 'aranha/parsers/source_address/fetch_content_error'
require 'aranha/parsers/source_address/hash_http_base'
require 'eac_envs/http/error'
require 'eac_envs/http/request'
require 'eac_ruby_utils/core_ext'
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

        def content
          request = http_request
          request.response.body_str
        rescue ::EacEnvs::Http::Error => e
          raise ::Aranha::Parsers::SourceAddress::FetchContentError, e.message, request
        end

        def param(key, default_value)
          source[key] || params[key] || default_value
        end

        def params
          source[:params].if_present(DEFAULT_PARAMS)
        end

        private

        # @return [EacEnvs::Http::Request]
        def http_request
          r = initial_http_request
          r = headers.if_present(r) { |v| r.headers(v) }
          r = body.if_present(r) { |v| r.body_data(v) }
          r = r.follow_redirect(true) if follow_redirect?
          r
        end

        # @return [EacEnvs::Http::Request]
        def initial_http_request
          ::EacEnvs::Http::Request.new.verb(self.class.http_method).url(url)
        end

        require_sub __FILE__
      end
    end
  end
end
