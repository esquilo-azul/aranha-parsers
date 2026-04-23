# frozen_string_literal: true

require 'nokogiri'

module Aranha
  module Parsers
    module Ofx
      class BodyParser
        class << self
          # @param content [String]
          # @return [Nokogiri::XML::Document]
          def parse(content)
            new(content).parse
          end
        end

        common_constructor :content

        # @return [Nokogiri::XML::Document]
        def parse
          r = ::Nokogiri::XML(content) do |config|
            config.strict
            config.noblanks
          end
          r.singleton_class.prepend(::Aranha::Parsers::Ofx::BodyParser::NodeExtension)
          r
        end
      end
    end
  end
end
