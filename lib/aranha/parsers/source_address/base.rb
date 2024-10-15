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

        # @return [Hash]
        def source_as_hash
          source_as_hash? ? source.with_indifferent_access : raise('source is not a Hash')
        end

        # @return [Boolean]
        def source_as_hash?
          source.is_a?(::Hash)
        end
      end
    end
  end
end
