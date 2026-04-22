# frozen_string_literal: true

require 'hpricot'

module Aranha
  module Parsers
    module Ofx
      class BodyParser
        class << self
          # @param content [String]
          # @return [Hpricot::Doc]
          def parse(content)
            new(content).parse
          end
        end

        common_constructor :content

        # @return [Hpricot::Doc]
        def parse
          ::Hpricot.XML(pre_process_content)
        end

        # @return [String]
        def pre_process_content
          content.gsub(/>\s+</m, '><')
            .gsub(/\s+</m, '<')
            .gsub(/>\s+/m, '>')
            .gsub(/<(\w+?)>([^<]+)/m, '<\1>\2</\1>')
        end
      end
    end
  end
end
