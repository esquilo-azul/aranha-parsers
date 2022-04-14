# frozen_string_literal: true

require 'aranha/parsers/source_address/hash_http_base'
require 'eac_ruby_utils/core_ext'
require 'httpclient'
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
        DEFAULT_PARAMS = {}.freeze

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

        def http_client_params
          [
            url,
            params.merge(body: body, follow_redirect: follow_redirect?)
          ]
        end

        def url
          source.fetch(:url)
        end

        def serialize
          source.to_yaml
        end

        def content
          HTTPClient.new.send("#{self.class.http_method}_content", *http_client_params)
        end

        def param(key, default_value)
          source[key] || params[key] || default_value
        end

        def params
          source[:params].if_present(DEFAULT_PARAMS)
        end
      end
    end
  end
end
