# frozen_string_literal: true

module Aranha
  module Parsers
    class SourceAddress
      class Base
        acts_as_abstract
        common_constructor :source
        compare_by :source

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

        # @|return [Hash]
        def source_as_uri
          source_as_uri? ? source.to_uri : raise('source is not a URI')
        end

        # @return [Boolean]
        def source_as_uri?
          source.to_uri.scheme.present?
        end

        # @return [Boolean]
        def valid?
          raise_abstract_method __method__
        end
      end
    end
  end
end
