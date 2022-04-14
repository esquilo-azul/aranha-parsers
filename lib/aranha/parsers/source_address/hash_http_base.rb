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

        common_constructor :source do
          self.source = source.with_indifferent_access
        end
        compare_by :source

        def url
          source.fetch(:url)
        end

        def serialize
          source.to_yaml
        end

        def content
          HTTPClient.new.send(
            "#{self.class.http_method}_content",
            source[:url],
            source[:params].merge(follow_redirect: true)
          )
        end
      end
    end
  end
end
