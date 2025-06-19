# frozen_string_literal: true

require 'eac_envs/http/error'
require 'eac_envs/http/request'

require 'yaml'

module Aranha
  module Parsers
    class SourceAddress
      class HashHttpBase < ::Aranha::Parsers::SourceAddress::Base
        class << self
          def http_method
            const_get 'HTTP_METHOD'
          end
        end

        DEFAULT_BODY = ''
        DEFAULT_FOLLOW_REDIRECT = true
        DEFAULT_HEADERS = {}.freeze
        DEFAULT_PARAMS = {}.freeze
        USER_AGENT_KEY = 'user-agent'
        USER_AGENT_VALUE = 'aranha-parsers'

        enable_simple_cache

        def body
          param(:body, DEFAULT_BODY)
        end

        def follow_redirect?
          param(:follow_redirect, DEFAULT_FOLLOW_REDIRECT)
        end

        def headers
          param(:headers, DEFAULT_HEADERS)
        end

        def serialize
          source_as_hash.to_yaml
        end

        def content
          request = http_request
          request.response.body_str!
        rescue ::EacEnvs::Http::Error => e
          raise ::Aranha::Parsers::SourceAddress::FetchContentError, e.message, request
        end

        def param(key, default_value)
          source_as_hash[key] || params[key] || default_value
        end

        def params
          source_as_hash[:params].if_present(DEFAULT_PARAMS)
        end

        # @return [Addressable::URI]
        def uri
          ::Addressable::URI.parse(source_as_hash.fetch(:url))
        end

        # @return [Boolean]
        def valid?
          source_as_hash? &&
            source_as_hash[:method].to_s.downcase.strip == self.class.http_method.to_s
        end

        private

        # @return [EacEnvs::Http::Request]
        def http_request
          r = initial_http_request
          r = headers.if_present(r) { |v| r.headers(initial_headers.merge(v).to_h) }
          r = body.if_present(r) { |v| r.body_data(v) }
          r = r.follow_redirect(true) if follow_redirect?
          r
        end

        # @return [Hash]
        def initial_headers
          ::Aranha::Parsers::SourceAddress::HashHttpBase::Headers.new
            .value(USER_AGENT_KEY, USER_AGENT_VALUE)
        end

        # @return [EacEnvs::Http::Request]
        def initial_http_request
          ::EacEnvs::Http::Request.new.verb(self.class.http_method).url(url)
            .headers(initial_headers.to_h)
        end

        require_sub __FILE__
      end
    end
  end
end
