# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Aranha
  module Parsers
    class SourceAddress
      class Base
        acts_as_abstract
        common_constructor :source
        compare_by :source

        class << self
          # @param source [Object]
          # @return [Boolean]
          def valid_source?(source) # rubocop:disable Lint/UnusedMethodArgument
            raise_abstract_method __method__
          end
        end

        # @return [String]
        def content
          raise_abstract_method __method__
        end

        # @return [Addressable::URI]
        def uri
          raise_abstract_method __method__
        end

        # @return [String]
        def url
          uri.to_s
        end
      end
    end
  end
end
