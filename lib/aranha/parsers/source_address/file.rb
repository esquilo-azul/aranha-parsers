# frozen_string_literal: true

module Aranha
  module Parsers
    class SourceAddress
      class File < ::Aranha::Parsers::SourceAddress::HttpGet
        SCHEME = 'file://'

        def initialize(source)
          super(source.to_s.gsub(/\A#{Regexp.quote(SCHEME)}/, ''))
        end

        def content
          ::File.read(source)
        end

        # @return [Addressable::URI]
        def uri
          source_as_uri? ? source_as_uri : "#{SCHEME}#{source}".to_uri
        end

        # @return [Boolean]
        def valid?
          source.to_s.start_with?("#{SCHEME}/", '/')
        end
      end
    end
  end
end
