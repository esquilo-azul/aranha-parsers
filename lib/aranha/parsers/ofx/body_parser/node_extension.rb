# frozen_string_literal: true

require 'nokogiri'

module Aranha
  module Parsers
    module Ofx
      class BodyParser
        module NodeExtension
          def collect(&block)
            r = []
            each do |e|
              r << block.call(prepend_extension(e))
            end
            r
          end

          def inner_text(*args)
            normalize_text(super)
          end

          alias text inner_text

          def prepend_extension(object)
            object.singleton_class.prepend(::Aranha::Parsers::Ofx::BodyParser::NodeExtension)
            object
          end

          def normalize_text(text)
            text.gsub(/\s+/, ' ').strip
          end

          def search(*args)
            prepend_extension(super)
          end

          alias / search
        end
      end
    end
  end
end
