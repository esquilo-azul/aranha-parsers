# frozen_string_literal: true

require 'aranha/parsers/html/node/base'
require 'eac_ruby_utils/core_ext'

module Aranha
  module Parsers
    module Html
      module Node
        class Default < ::Aranha::Parsers::Html::Node::Base
          require_sub __FILE__, include_modules: true

          # @param node [Nokogiri::XML::Node]
          # @param xpath [String]
          # @return [Boolean]
          def boolean_value(node, xpath)
            node_value(node, xpath).to_bool
          end

          # @param node [Nokogiri::XML::Node]
          # @param xpath [String]
          # @return [Nokogiri::XML::NodeSet]
          def node_set_value(node, xpath)
            node.xpath(xpath)
          end

          # @param node [Nokogiri::XML::Node]
          # @param xpath [String]
          # @return [Nokogiri::XML::Node]
          def node_value(node, xpath)
            node.at_xpath(xpath)
          end
        end
      end
    end
  end
end
