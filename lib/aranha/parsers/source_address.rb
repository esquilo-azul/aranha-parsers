# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require 'eac_ruby_utils/require_sub'
require 'yaml'

module Aranha
  module Parsers
    class SourceAddress
      ::EacRubyUtils.require_sub __FILE__

      class << self
        SUBS = [
          ::Aranha::Parsers::SourceAddress::HashHttpGet,
          ::Aranha::Parsers::SourceAddress::HashHttpPost,
          ::Aranha::Parsers::SourceAddress::HttpGet,
          ::Aranha::Parsers::SourceAddress::File
        ].freeze

        def detect_sub(source)
          return source.sub if source.is_a?(self)

          SUBS.each do |sub|
            return sub.new(source) if sub.valid_source?(source)
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

      attr_reader :sub

      def initialize(source)
        @sub = self.class.detect_sub(source)
      end

      delegate :content, :url, to: :sub

      def to_s
        sub.url
      end

      def serialize
        sub.serialize.strip + "\n"
      end
    end
  end
end
