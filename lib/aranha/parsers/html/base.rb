# frozen_string_literal: true

require 'nokogiri'

module Aranha
  module Parsers
    module Html
      class Base < ::Aranha::Parsers::Base
        class << self
          def fields
            @fields ||= []
            @fields.dup
          end

          def field(name, type, xpath)
            @fields ||= []
            @fields << Field.new(name, type, xpath)
          end

          # @param node [Nokogiri::XML::Node]
          # @return [Aranha::Parsers::Html::Base]
          def from_node(node)
            from_string(node.to_html)
          end

          # @param node [String]
          # @param klass [String]
          # @return [String]
          def xpath_contains_class(klass, node = '@class')
            "contains(concat(' ', normalize-space(#{node}), ' '), ' #{klass} ')"
          end

          # @param haystack [String]
          # @param needle [String]
          # @return [String]
          def xpath_ends_with(haystack, needle)
            "substring(#{haystack}, string-length(#{haystack}) - string-length(#{needle}) + 1) " \
              "= #{needle}"
          end

          Field = Struct.new(:name, :type, :xpath)
        end

        def nokogiri
          @nokogiri ||= Nokogiri::HTML(content, &:noblanks)
        end

        protected

        def node_parser_class
          ::Aranha::Parsers::Html::Node::Default
        end

        private

        def node_parser
          @node_parser ||= node_parser_class.new(fields)
        end

        def fields
          self.class.fields.map { |f| [f.name, f.type, f.xpath] }
        end
      end
    end
  end
end
