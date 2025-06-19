# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'

require 'yaml'

module Aranha
  module Parsers
    class SourceAddress
      require_sub __FILE__

      class << self
        SUBS = [
          ::Aranha::Parsers::SourceAddress::HashHttpGet,
          ::Aranha::Parsers::SourceAddress::HashHttpPost,
          ::Aranha::Parsers::SourceAddress::HttpGet,
          ::Aranha::Parsers::SourceAddress::File
        ].freeze

        def detect_sub(source)
          return source.sub if source.is_a?(self)

          SUBS.each do |sub_class|
            sub_class.new(source).then do |sub|
              return sub if sub.valid?
            end
          end
          raise "No content fetcher found for source \"#{source}\""
        end

        def deserialize(string)
          new(string =~ %r{\A[a-z]+://} ? string.strip : ::YAML.load(string)) # rubocop:disable Security/YAMLLoad
        end

        def from_file(path)
          deserialize(::File.read(path))
        end
      end

      enable_simple_cache
      common_constructor :source
      delegate :content, :url, to: :sub

      def to_s
        sub.url
      end

      def serialize
        "#{sub.serialize.strip}\n"
      end

      private

      def sub_uncached
        self.class.detect_sub(source)
      end
    end
  end
end
